{ inputs, activateDebug ? false }:
with inputs;
with builtins;
let total = rec {
  sharedAttrs = attrs1: attrs2: pkgslib.attrsets.genAttrs (attrNames attrs1) (attr: elem attr (attrNames attrs2));
    onlyProperlyTaggedSharedAttrs = sharedAttrsResult: pkgslib.attrsets.filterAttrs (key: _val: key == "shared") sharedAttrsResult;
    sharedAttrsAreTaggedAsSuch = sharedAttrsResult: onlyProperlyTaggedSharedAttrsResult: length (attrNames sharedAttrsResult) == length (attrNames onlyProperlyTaggedSharedAttrsResult);
    theAboveSummarized = attrs1: attrs2: let
      sharedAttrsResult = sharedAttrs attrs1 attrs2;
      onlyProperlyTaggedSharedAttrsResult = onlyProperlyTaggedSharedAttrs sharedAttrsResult;
    in sharedAttrsAreTaggedAsSuch sharedAttrsResult onlyProperlyTaggedSharedAttrsResult;
    forGivenModuleCheckProperSharedTagWrtRest = modulesAttrs: moduleName: val: mapAttrs (moduleName': val': theAboveSummarized val val') (removeAttrs modulesAttrs [ moduleName ]);
    checkingAllModulesForTheAbove = modulesAttrs: mapAttrs (forGivenModuleCheckProperSharedTagWrtRest modulesAttrs) modulesAttrs;
    whoFails = modulesAttrs: pkgslib.filterAttrs (_moduleName: val: val == false) (checkingAllModulesForTheAbove modulesAttrs);
    final = rec {
      predName = "sharedAttrsAreMarkedAsSuch";
      function = modulesAttrs: let 
        failuresAsStrList = attrNames (whoFails modulesAttrs);
      in {
        testresult = 0 < length failuresAsStrList;
        failures = failuresAsStrList;
      };
      handler = { target, type }: let test = function target; in
      if !test.testresult then
        target 
      else 
        (tclib.stdTcError { inherit type predName; }) + "; the following attributes are shared yet not marked as such: ${toString test.failures}";
    };
};
in baselib.wrapDebug {
  inherit total activateDebug;
}

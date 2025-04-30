{ prelib, pkgslib }:
{ target, activateDebug ? false }:
with builtins;
let total = rec {
  sharedAttrs = attrs1: attrs2: pkgslib.attrsets.genAttrs (attrNames attrs1) (attr: elem attr (attrNames attrs2));
  onlyAttrsThatAreShared = sharedAttrsResult: pkgslib.attrsets.filterAttrs (_key: val: val == true) sharedAttrsResult;
  sharedAttrsAreTaggedAsSuch = attrs1: attrs2: let
    sharedAttrsResult = sharedAttrs attrs1 attrs2;
    onlyAttrsThatAreSharedResult = onlyAttrsThatAreShared sharedAttrsResult;
  in if length (attrNames onlyAttrsThatAreSharedResult) > 0 then
    length (attrNames onlyAttrsThatAreSharedResult) == 1 && elem "shared" (attrNames onlyAttrsThatAreSharedResult)
  else
    true;
  forGivenModuleCheckProperSharedTagWrtRest = moduleName: val: mapAttrs (moduleName': val': sharedAttrsAreTaggedAsSuch val val') (removeAttrs target [ moduleName ]);
  checkingAllModulesForTheAbove = mapAttrs forGivenModuleCheckProperSharedTagWrtRest target;
  whoFails = pkgslib.filterAttrs (_moduleName: val: elem false (attrValues val)) checkingAllModulesForTheAbove;
  whatFails = mapAttrs (key: val: attrNames (pkgslib.filterAttrs (_comparedModule: val': val' == false) val)) whoFails;
  whatFailsAsPairs = map (name: { key = name; val = whatFails.${name}; }) (attrNames whatFails);
  whatFailsToStringFold = acc: next: acc + "${next.key} : ${concatStringsSep " " next.val};\n";
  coerceWhatFailsToString = foldl' whatFailsToStringFold "" whatFailsAsPairs;
  final = {
    testresult = whatFails == {};
    failures = coerceWhatFailsToString;
  };
}; in prelib.wrapDebug {
  inherit total activateDebug;
}

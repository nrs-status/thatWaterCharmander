{ prelib, pkgslib }:
{ target, activateDebug ? false }:
with builtins;
let total = rec {
  #no two attributes are shared
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

  #an attribute that is both within 'shared' and outside
  hasAttrsInShared = key: if hasAttr "shared" target then elem k (attrNames target.shared) else false;
  whoHasAttrsInShared = mapAttrs (k: _v: hasAttrsInShared k) target;
  onlyThoseHavingAttrsInShared = pkgslib.filterAttrs (_k: v: v == true) whoHasAttrsInShared;

  final = {
    testresult = (whatFails == {}) && (onlyThoseHavingAttrsInShared == {});
    failures = "attrs that should be marked shared found in: ${pkgslib.generators.toKeyValue whatFails} \n
      attrs both tagged and untagged wrt 'shared: ${pkgslib.generators.toKeyValue onlyThoseHavingAttrsInShared}";
  };
}; in prelib.wrapDebug {
  inherit total activateDebug;
}

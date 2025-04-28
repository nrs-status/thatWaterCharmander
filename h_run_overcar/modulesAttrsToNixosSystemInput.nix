{ baselib }:
{ typecheckedNixosDecl, activateDebug ? false}:
with builtins;
let total = rec {
  unlabelModulesAndConcat = baselib.concatAttrSets (attrValues typecheckedNixosDecl);
  removeShared = removeAttrs unlabelModulesAndConcat [ "shared" ];
  final = unlabelModulesAndConcat.shared // removeShared;
}; in baselib.wrapDebug {
  inherit total activateDebug;
}


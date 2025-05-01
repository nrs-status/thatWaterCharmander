{ prelib, baselib }:
args@{ typecheckedNixosDecl, activateDebug ? false}:
with builtins;
let total = rec {
  asList = attrValues typecheckedNixosDecl;
  unlabelModulesAndConcat = foldl' baselib.deepMerge {} asList;
  removeShared = removeAttrs unlabelModulesAndConcat [ "shared" ];
  final = unlabelModulesAndConcat.shared // removeShared;
  debug = { inherit args; };
}; in prelib.wrapDebug {
  inherit total activateDebug;
}


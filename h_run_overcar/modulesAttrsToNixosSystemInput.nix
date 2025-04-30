{ prelib, baselib }:
args@{ typecheckedNixosDecl, activateDebug ? false}:
with builtins;
let total = rec {
  unlabelModulesAndConcat = foldl' baselib.deepMerge {} (attrValues typecheckedNixosDecl);
  removeShared = removeAttrs unlabelModulesAndConcat [ "shared" ];
  final = unlabelModulesAndConcat.shared // removeShared;
  debug = { inherit args; };
}; in prelib.wrapDebug {
  inherit total activateDebug;
}


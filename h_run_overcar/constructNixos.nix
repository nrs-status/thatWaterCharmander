{ baselib, activateDebug ? false }:
{ selectedModules }:
with builtins;
let total = rec {
  toList = map (moduleName: { ${moduleName} = selectedModules.${moduleName}; }) (attrNames selectedModules);
  final = foldl' baselib.deepMerge toList;
}; in baselib.wrapDebug {
  inherit total activateDebug;
}

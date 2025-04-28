{ inputs, activateDebug ? false }:
{ modulesAttrs }:
with inputs;
with builtins;
let total = {
  toList = map (moduleName: { ${moduleName} = modulesAttrs.${moduleName}}) (attrNames modulesAttrs);
  final = foldl' baselib.deepMerge toList;
}; in baselib.wrapDebug {
  inherit total activateDebug;
}

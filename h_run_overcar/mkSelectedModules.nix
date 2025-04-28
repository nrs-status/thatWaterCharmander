{ pkgslibs, baselib }:
{ moduleNameList, modulesAttrs, activateDebug ? false }:
with builtins;
let total = {
  removeUnselected = pkgslib.attrsets.filterAttrs (key: _val: elem key moduleNameList) modulesAttrs;
  final = removeUnselected;
}; in baselib.wrapDebug {
  inherit total activateDebug;
}

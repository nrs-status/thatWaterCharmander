{ prelib, baselib, pkgslib, tclib, activateDebug ? false }:
let total = rec {
  final = rec {
    predName = "sharedAttrsAreMarkedAsSuch";
    function = target: import ./sharedAttrsAreMarkedAsSuch_function.nix { inherit prelib baselib pkgslib; } { inherit target; };
    handler = { target, type }: let
      test = function target;
    in if test.testresult then
      target
    else
      abort ((tclib.stdTcError { inherit type predName; }) + "; ${test.failures}");
  };
}; in prelib.wrapDebug {
  inherit total activateDebug;
}

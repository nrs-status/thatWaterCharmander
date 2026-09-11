{ lclInputs, activateDebug ? false }:
{
  typeName = "NixosDecl";
  spec = [
    {
      path = [ ];
      pred = {
        predName = "atMostDockerOrPodman";
        func = target:
          !(import ../predicates/atMostDockerOrPodman.nix {
            inherit (lclInputs) pkgslib tclib;
            inherit activateDebug;
          }).function target;
      };
    }
    {
      path = [ ];
      pred = {
        predName = "sharedAttrsAreMarkedAsSuch";
        func = target:
          (import ../predicates/sharedAttrsAreMarkedAsSuch.nix {
            inherit (lclInputs) prelib baselib pkgslib tclib;
            inherit activateDebug;
          }).function target.testresult;
      };
    }
  ];
}

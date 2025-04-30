{ lclInputs, activateDebug ? false }:
{
  typeName = "NixosDecl";
  preds = [
    (import ../predicates/atMostDockerOrPodman.nix { inherit lclInputs activateDebug; })
    (import ../predicates/sharedAttrsAreMarkedAsSuch.nix (with lclInputs; { inherit prelib baselib pkgslib tclib activateDebug; }))
  ];
}

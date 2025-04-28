{ inputs, activateDebug ? false }:
{
  typeName = "NixosDecl";
  preds = [
    import ./predicates/atMostDockerOrPodman.nix { inherit inputs activateDebug; }
    import ./predicates/sharedAttrsAreMarkedAsSuch.nix { inherit inputs activateDebug; }
  ];
}

{ baselib, pkgslib }:
{
  constructNixos = import ./constructNixos.nix { inherit baselib; };
  mkSelectedModules = import ./mkSelectedModules.nix { inherit baselib pkgslib; };
  modulesAttrsToNixosSystemInput = import ./modulesAttrsToNixosSystemInput.nix { inherit baselib; };
}

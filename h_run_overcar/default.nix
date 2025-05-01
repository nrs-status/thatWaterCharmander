{ prelib, baselib, pkgslib }:
{
  grabSelectedModulesFromWhole = import ./grabSelectedModulesFromWhole.nix { inherit prelib baselib; };
  mkSelectedModules = import ./mkSelectedModules.nix { inherit baselib pkgslib prelib; };
  modulesAttrsToNixosSystemInput = import ./modulesAttrsToNixosSystemInput.nix { inherit prelib baselib; };
}

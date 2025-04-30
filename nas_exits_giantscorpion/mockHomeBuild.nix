with builtins;
rec {
  flakes = {
    frontArmToPlane = getFlake "github:nrs-status/frontArmToPlane";
    homeManagerFlake = getFlake "github:nix-community/home-manager/release-24.11";
  };
  shells = flakes.frontArmToPlane.devShells.x86_64.w2411;
  bp = flakes.frontArmToPlane.byproducts.x86_64-linux.w2411;
  nixpkgs = bp.nixpkgs;
  pkgs = bp.pkgs;
  pkgslib = pkgs.lib;
  baselib = bp.lclInputs.baselib;
  tclib = bp.lclInputs.tclib;
  types = baselib.mkTypesAttrs {
    typesdir = ../kaoun_slides_totem;
    importsToPass = {
      lclInputs = { inherit pkgslib baselib tclib; };
    };
  };
  mockHomeExtensions = [{
    wayland.windowManager.sway = import ../zeus_olympia/sway/resources/swayDecl.nix { inherit pkgs pkgslib; };
    programs.waybar = import ../zeus_olympia/sway/resources/waybarDecl.nix { inherit pkgs; };
  }];
  mockHome = baselib.mkHMOutput {
    inherit mockHomeExtensions pkgs;
    stateVersion = "24.11";
    homeManagerFlake = flakes.homeManagerFlake;
  };
  extractFiles = baselib.mkMockHMOutputAndExtractFiles {
    stateVersion = "24.11";
    homeManagerFlake = flakes.homeManagerFlake;
    inherit mockHomeExtensions pkgs;
    attrsOfPathsStartingAtPlaceholderHome = {
      swayConf = /sway/config;
      waybarConf = /waybar/config;
    };
  };
}

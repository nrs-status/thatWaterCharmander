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
  homeManagerFlake = flakes.homeManagerFlake;
  mockHomeExtension1 = {
    programs.waybar = import ../zeus_olympia/sway/resources/waybarDecl.nix { inherit pkgs; };
  };
  hm1 = baselib.mkMockHMOutputAndExtractFiles {
    stateVersion = "24.11";
    inherit homeManagerFlake pkgs;
    mockHomeExtensions = [ mockHomeExtension1 ];
    attrsOfPathsStartingAtPlaceholderHome = {
      waybarConfig = /waybar/config;
    };
  };
  waybarConfigDeriv = pkgs.writeTextFile { name = "waybarConfig"; text = hm1.waybarConfig; };
  waybarCommand = "${pkgs.waybar}/bin/waybar --config ${waybarConfigDeriv}";
  mockHomeExtension2 = {
    wayland.windowManager.sway = import ../zeus_olympia/sway/resources/swayDecl.nix { 
      inherit pkgs pkgslib waybarCommand; 
    };
  };
  hm2 = baselib.mkMockHMOutputAndExtractFiles {
    stateVersion = "24.11";
    inherit homeManagerFlake pkgs;
    mockHomeExtensions = [ mockHomeExtension2 ];
    attrsOfPathsStartingAtPlaceholderHome = {
      swayConfig = /sway/config;
    };
  };
  swayConfigDeriv = pkgs.writeTextFile { name = "swayConfig"; text = hm2.swayConfig; };
  sway = {
      shared = {
        environment.systemPackages = systemPackages;
        programs = {
          waybar = {
            enable = true;
            package = pkgs.waybar;
          };
          sway = {
            enable = true;
            package = pkgs.sway;
            extraOptions = [ "--config ${swayConfigDeriv}" ];
          };
        };
      };
  };
}

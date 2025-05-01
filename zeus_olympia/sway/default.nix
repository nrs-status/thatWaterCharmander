{ lclInputs, pkgs, activateDebug ? false, ... }:
with lclInputs;
let total = rec {
  mockHomeExtension1 = {
    programs.waybar = import ./resources/waybarDecl.nix { inherit pkgs; };
  };
  hm1 = baselib.mkMockHMOutputAndExtractFiles {
    stateVersion = "24.11";
    inherit homeManagerFlake pkgs prelib;
    mockHomeExtensions = [ mockHomeExtension1 ];
    attrsOfPathsStartingAtPlaceholderHome = { 
      waybarConfig = /waybar/config;
    };
  };
  waybarConfigDeriv = pkgs.writeTextFile {
    name = "waybarConfig";
    text = hm1.waybarConfig;
  };
  waybarCommand = "${pkgs.waybar}/bin/waybar --config ${waybarConfigDeriv}";
  mockHomeExtension2 = {
    wayland.windowManager.sway = import ./resources/swayDecl.nix {
      inherit pkgslib pkgs waybarCommand;
    };
  };
  hm2 = baselib.mkMockHMOutputAndExtractFiles {
    stateVersion = "24.11";
    inherit homeManagerFlake pkgs prelib;
    mockHomeExtensions = [ mockHomeExtension2 ];
    attrsOfPathsStartingAtPlaceholderHome = {
      swayConfig = /sway/config;
    };
  };
  swayConfigDeriv = pkgs.writeTextFile {
    name = "swayConfig";
    text = hm2.swayConfig;
  };
  systemPackages = with pkgs; [
    grim #screenshot tool
    slurp #allows selecting a piece of screen for screenshot
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    mako # notification system developed by swaywm maintainer
    wev #xev analogue
    remontoire #list keybindings
    killall #for toggling swaybar
  ];
  final = {
      shared = {
        environment.systemPackages = systemPackages;

      #useful for debug: 
      #environment.sessionVariables.SWAYCONFDIR = swayConfigDeriv;

        programs = {
          waybar = {
            enable = true;
            package = pkgs.waybar;
          };
          sway = {
            enable = true;
            package = pkgs.sway;
            extraOptions = [ "--config=${swayConfigDeriv}" ];
          };
        };
      };
  };
}; in prelib.wrapDebug {
  inherit total activateDebug;
}

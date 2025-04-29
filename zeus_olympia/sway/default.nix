{ lclInputs, pkgs, ... }:
with lclInputs;
let 
  mockHomeExtension = {
    wayland.windowManager.sway = import ./resources/swayDecl.nix {
      inherit pkgs pkgslib;
    };
  };
  configDeriv = pkgs.writeTextFile (baselib.createMockHMOutputAndExtractFiles {
    elemAtIndex = 1;
    stateVersion = "24.11";
    inherit homeManagerFlake mockHomeExtension;
    attrsOfPathsStartingAtPlaceholderHome = { swayConfig = /sway/config; };
  }).swayConfig;
in {
  shared = {
    environment.systemPackages = with lclInputs.pkgs; [
        grim #screenshot tool
        slurp #allows selecting a piece of screen for screenshot
        wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
        mako # notification system developed by swaywm maintainer
        wev #xev analogue
        remontoire #list keybindings
    ];
    programs = {
      waybar = import ./resources/waybarDecl.nix { pkgs = lclInputs.pkgs; };
      sway = {
        enable = true;
        package = pkgs.sway;
        extraOptions = [ "--config ${configDeriv}" ];
      };
    };

  };

}

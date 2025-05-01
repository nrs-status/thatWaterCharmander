with builtins;
rec {
  flake = getFlake "github:nrs-status/thatWaterCharmander";
  config = flake.outputs.nixosConfigurations.wranHearst.config;
  services = config.systemd.services;
  pkgs = import <nixpkgs> {};
  pkgslib = pkgs.lib;
  enabledFiltering = mapAttrs (_k: v: v.enable == true) services;
  onlyDisabled = pkgslib.filterAttrs (_k: v: v == false) enabledFiltering;
}

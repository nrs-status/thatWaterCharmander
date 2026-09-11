{ lclInputs, system, activateDebug ? false, ... }:
with lclInputs;
let total = rec {
  fileSystems = {
    "/" = { 
      device = "/dev/disk/by-uuid/10d222ac-e7e3-41b2-a99c-e9fabe197b84";
      fsType = "btrfs";
    };
    "/boot" = { 
      device = "/dev/disk/by-uuid/13B6-D3B7";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  };
  shared.hardware = {
    graphics = {
      enable = true; #this is opengl; needed for sway
    };
    cpu.intel.updateMicrocode = lclInputs.pkgslib.mkDefault true;
    enableRedistributableFirmware = true; # journalctl -b will report firmware failures otherwise; sway will fail to run; the wireless interface will not be recognized
  };
  final = { inherit fileSystems shared; };
}; in prelib.wrapDebug {
  inherit total activateDebug;
}

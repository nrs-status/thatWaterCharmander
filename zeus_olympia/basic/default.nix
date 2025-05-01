{ lclInputs, system, pkgs, ... }:
{
  system.stateVersion = "24.11";

  shared = { 
    programs.light.enable = true; # cannot modify /sys/class/backlight/intel_backlight otherwise
    users.users.sieyes = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "docker"
        "networkmanager"
        "audio"
        "video"
      ];
    };
    environment = { 
      variables = {
        EDITOR = "nvim";
      };
      systemPackages = with pkgs; [
	  vim
          curl
          git
          keyd
          ripgrep
          eza
          bat
          pciutils #for debugging drivers and hardware
        ];
    };
  };
}

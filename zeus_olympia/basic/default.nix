{ lclInputs, system, pkgs, ... }:
{
  system.stateVersion = "24.11";

  shared = { 
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

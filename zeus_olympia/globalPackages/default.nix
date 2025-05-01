{ lclInputs, system, pkgs, ... }:
{

  shared = { 
      programs.direnv.enable = true;
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

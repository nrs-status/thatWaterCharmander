{ lclInputs, system, pkgs, ... }: {

  shared = {
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
    };
    environment.systemPackages = with pkgs; [
      vim
      curl
      git
      keyd
      ripgrep
      eza
      bat
      pciutils # for debugging drivers and hardware
    ];
  };
}

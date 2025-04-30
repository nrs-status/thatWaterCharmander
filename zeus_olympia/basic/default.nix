{ lclInputs, system, ... }:
{ basic = {
  system.stateVersion = "24.11";

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
  };
  shared.environment.systemPackages = with lclInputs.pkgs; [
        curl
        git
        keyd
      ];
    };
  }

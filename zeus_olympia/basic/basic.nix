{ inputs }:
{
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
    shell = inputs.pkgs.fish;
  };

  environment = {
    variables = {
      EDITOR = "nvim";
    };
  };
  shared.environment.systemPackages = with inputs.pkgs; [
        curl
        git
        keyd
      ];
    };
  };
}

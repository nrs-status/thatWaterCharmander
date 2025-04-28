{ inputs }:
{
  security.rtkit.enable = true
  security = {
    rtkit.enable = true;
    #passwordless access to rfkill so bluetooth can be toggled
    sudo.extraRules = [{
      groups = [ "wheel" ];
      command = [{
        "/run/current-system/sw/bin/rfkill";
      }];
      options = ["NOPASSWD"];
    }];
  };
}

{ inputs }:
{
  networking = {
    hostName = inputs.pkgs.lib.mkDefault "wranHearst";
  };

  services.openssh.enable = true;
}

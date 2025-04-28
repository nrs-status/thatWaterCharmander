{ inputs }:
{
  networking = {
    hostName = inputs.pkgslib.mkDefault "wranHearst";
  };

  services.openssh.enable = true;
}

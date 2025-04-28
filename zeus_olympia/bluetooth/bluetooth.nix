{ inputs }:
{
  shared.environment.systemPackages = with inputs.pkgs; [
    bluez
    blueman
  ];
}

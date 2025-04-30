{ lclInputs, system, ... }:
{ bluetooth = {
  shared.environment.systemPackages = with lclInputs.pkgs; [
    bluez
    blueman
  ];
};
}

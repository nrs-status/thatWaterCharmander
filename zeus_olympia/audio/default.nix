{ lclInputs, system, pkgs, ... }:
{
  shared = {
    environment.systemPackages = with pkgs; [
      pavucontrol
      pulseaudio
    ];
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.pulseaudio.enable = false;
  };
}

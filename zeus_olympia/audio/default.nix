{ lclInputs, system, ... }:
{
  shared = {
    pulseaudio.enable = false;
    environment.systemPackages = with lclInputs.pkgs; [
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

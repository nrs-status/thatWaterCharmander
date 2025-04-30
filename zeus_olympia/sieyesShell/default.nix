{ lclInputs, ... }:
{
  shared.programs.fish.enable = true; #must be added otherwiese the shell decl in users triggers error
  shared.users.users.sieyes = {
    shell = lclInputs.pkgs.fish;
    #shell = lclInputs.shells.workEnv;
  };
}

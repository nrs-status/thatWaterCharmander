with builtins;
rec {
  flakes = {
    frontArmToPlane = getFlake "github:nrs-status/frontArmToPlane";
    homeManagerFlake = getFlake "github:nix-community/home-manager/release-24.11";
  };
  homeManagerFlake = flakes.homeManagerFlake;
  shells = flakes.frontArmToPlane.devShells.x86_64.w2411;
  bp = flakes.frontArmToPlane.byproducts.x86_64-linux.w2411;
  nixpkgs = bp.nixpkgs;
  pkgs = bp.pkgs;
  pkgslib = pkgs.lib;
  baselib = bp.lclInputs.baselib;
  prelib = bp.lclInputs.prelib;
  tclib = bp.lclInputs.tclib;
  types = baselib.mkTypesAttrs {
    typesdir = ../kaoun_slides_totem;
    importsToPass = {
      lclInputs = { inherit prelib pkgslib baselib tclib; };
    };
  };
  lcllib = import ../h_run_overcar { inherit prelib pkgslib baselib; };

    modulesAttrs = prelib.importPairAttrsOfDir {
      filePathForRecursiveFileListing = ../zeus_olympia;
      inputForImportPairs = {
        system = "x86_64-linux";
        lclInputs = {inherit pkgslib tclib baselib shells prelib homeManagerFlake;};
        inherit pkgs;
      };
    };


  selectedModules = lcllib.mkSelectedModules {
    inherit modulesAttrs;
    moduleNameList = import ../emp_triage_can/wranHearst.nix;
  };
  totalModule = lcllib.constructNixos { inherit selectedModules; };
  modules = tclib.typecheck {
    target = totalModule;
    type = types.NixosDecl;
  };
  result = import ../h_run_overcar/modulesAttrsToNixosSystemInput.nix { inherit prelib baselib; } {
    typecheckedNixosDecl = modules;
    activateDebug = false;
  };
}

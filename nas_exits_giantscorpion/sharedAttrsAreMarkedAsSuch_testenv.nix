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
  tclib = bp.lclInputs.tclib;
  types = baselib.mkTypesAttrs {
    typesdir = ../kaoun_slides_totem;
    importsToPass = {
      lclInputs = { inherit pkgslib baselib tclib; };
    };
  };
  lcllib = import ../h_run_overcar { inherit pkgslib baselib; };

    modulesAttrs = baselib.importPairAttrsOfDir {
      filePathForRecursiveFileListing = ../zeus_olympia;
      inputForImportPairs = {
        system = "x86_64-linux";
        lclInputs = {inherit pkgslib tclib baselib shells homeManagerFlake;};
        inherit pkgs;
      };
    };


  selectedModules = lcllib.mkSelectedModules {
    inherit modulesAttrs;
    moduleNameList = import ../emp_triage_can/wranHearst.nix;
  };
  totalModule = lcllib.constructNixos { inherit selectedModules; };
  sharedAttrsAreMarkedAsSuch = import ../kaoun_slides_totem/predicates/sharedAttrsAreMarkedAsSuch_function.nix {
    inherit baselib pkgslib;
  };
  a = totalModule.audio;
  b = totalModule.keyRemappings;
  c = totalModule.nix;
  result = sharedAttrsAreMarkedAsSuch { 
    target = totalModule; 
    activateDebug = true; 
  };

  thePredicate = import ../kaoun_slides_totem/predicates/sharedAttrsAreMarkedAsSuch.nix {
    inherit baselib pkgslib tclib;
  };
  atype = {
    typeName = "mytype";
    preds = [ thePredicate ];
  };
  result' = tclib.typecheck {
    target = totalModule;
    type = types.NixosDecl;
    activateDebug = true;
  };
  result'' = tclib.typecheck {
    target = totalModule;
    type = atype;
    activateDebug = true;
  };
}

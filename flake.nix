{
  inputs = {
    frontArmToPlane.url = github:nrs-status/frontArmToPlane;
    homeManagerFlake.url = github:nix-community/home-manager/release-24.11;
  };
  outputs = inputs: let total = rec {

    #init
    shells = inputs.frontArmToPlane.devShells.x86_64-linux.w2411;
    bp = inputs.frontArmToPlane.byproducts.x86_64-linux.w2411;
    nixpkgs = bp.nixpkgs;
    pkgs = bp.pkgs;

    #lib decls
    pkgslib = pkgs.lib;
    prelib = bp.lclInputs.prelib;
    baselib = bp.lclInputs.baselib;
    tclib = bp.lclInputs.tclib;
    types = baselib.mkTypesAttrs {
      typesdir = ./kaoun_slides_totem;
      importsToPass = {
        lclInputs = { inherit prelib pkgslib baselib tclib; };
      };
    };
    lcllib = import ./h_run_overcar { inherit prelib pkgslib baselib; };

    #construct nixpkgs.lib.nixosSystem input
    modulesAttrs = prelib.importPairAttrsOfDir {
      filePathForRecursiveFileListing = ./zeus_olympia;
      inputForImportPairs = {
        system = "x86_64-linux";
        lclInputs = {
          inherit prelib pkgslib tclib baselib shells;
          homeManagerFlake = inputs.homeManagerFlake;
      };
        inherit pkgs;
      };
    };
    selectedModules = lcllib.mkSelectedModules {
      inherit modulesAttrs;
      moduleNameList = import ./emp_triage_can/wranHearst.nix;
    };
    grabbedModulesFromWhole = lcllib.grabSelectedModulesFromWhole { inherit selectedModules; };
    typecheckedNixosDecl = tclib.typecheck {
      target = grabbedModulesFromWhole;
      type = types.NixosDecl;
      activateDebug = false;
    };
    toNixosModule = lcllib.modulesAttrsToNixosSystemInput { 
      inherit typecheckedNixosDecl; 
      activateDebug = false; 
    };

    #flake output
    final = { 
      nixosConfigurations."wranHearst" = nixpkgs.lib.nixosSystem { modules = [ toNixosModule ]; };
      debug = {
        inherit types toNixosModule;
      };
  };
  };
  in total.prelib.wrapDebug {
    inherit total;
    activateDebug = true;
  };
}

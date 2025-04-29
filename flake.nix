{
  inputs = {
    frontArmToPlane.url = github:nrs-status/frontArmToPlane;
    homeManagerFlake.url = github:nix-community/home-manager;
  };
  outputs = inputs: let total = rec {
    shells = inputs.frontArmToPlane.devShells.x86_64-linux.w2411;
    bp = inputs.frontArmToPlane.byproducts.x86_64-linux.w2411;
    nixpkgs = bp.nixpkgs;
    pkgs = bp.pkgs;
    pkgslib = pkgs.lib;
    baselib = bp.lclInputs.baselib;
    tclib = bp.lclInputs.tclib;
    types = baselib.mkTypesAttrs {
      typesdir = ./kaoun_slides_totem;
      importsToPass = {
        inputs = { inherit pkgslib baselib tclib; };
      };
    };
    lcllib = import ./h_run_overcar { inherit pkgslib baselib; };
    homeManagerFlake = inputs.homeManagerFlake;
    modulesAttrs = baselib.importPairAttrsOfDir {
      filePathForRecursiveFileListing = ./zeus_olympia;
      inputForImportPairs = {
        system = "x86_64-linux";
        inputs = { inherit pkgslib tclib baselib pkgs shells homeManagerFlake; };
      };
    };
    selectedModules = lcllib.mkSelectedModules {
      inherit modulesAttrs;
      moduleNameList = import ./emp_triage_can/wranHearst.nix;
    };
    totalModule = lcllib.constructNixos { inherit selectedModules; };
    modules = tclib.typecheck {
      target = totalModule;
      type = types.NixosDecl;
      activateDebug = false;
    };
    nixosSystemInput = { modules = [ (lcllib.modulesAttrsToNixosSystemInput { typecheckedNixosDecl = modules; }) ]; };
    final = { 
      packages."x86_64-linux".nixosConfigurations.wranHearst = nixpkgs.lib.nixosSystem nixosSystemInput;
      debug = {
        inherit types;
      };
  };
  };
  in total.baselib.wrapDebug {
    inherit total;
    activateDebug = false;
  };
}

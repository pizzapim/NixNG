{ nglib, nixpkgs, ... }:
nglib.makeSystem {
  inherit nixpkgs;
  system = "x86_64-linux";
  name = "nixng-bazarr";

  config =
    { ... }:
    {
      dinit.enable = true;
      init.services.bazarr.shutdownOnExit = true;

      services.bazarr = {
        enable = true;
        configDir = "/cfg";
      };
    };
}

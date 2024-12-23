{ nglib, nixpkgs, ... }:
nglib.makeSystem {
  inherit nixpkgs;
  system = "x86_64-linux";
  name = "nixng-prowlarr";

  config =
    { ... }:
    {
      dinit.enable = true;
      init.services.prowlarr.shutdownOnExit = true;

      services.prowlarr = {
        enable = true;
        dataDir = "/data";
      };
    };
}

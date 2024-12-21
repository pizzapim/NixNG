{ nglib, nixpkgs, ... }:
nglib.makeSystem {
  inherit nixpkgs;
  system = "x86_64-linux";
  name = "nixng-radarr";

  config =
    { ... }:
    {
      dinit.enable = true;
      init.services.radarr.shutdownOnExit = true;
      services.radarr.enable = true;
    };
}

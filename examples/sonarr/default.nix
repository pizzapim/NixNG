{ nglib, nixpkgs, ... }:
nglib.makeSystem {
  inherit nixpkgs;
  system = "x86_64-linux";
  name = "nixng-sonarr";

  config =
    { ... }:
    {
      dinit.enable = true;
      init.services.sonarr.shutdownOnExit = true;
      services.sonarr.enable = true;
    };
}

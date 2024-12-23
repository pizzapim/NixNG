{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.services.prowlarr;
in
{
  options.services.prowlarr = {
    enable = lib.mkEnableOption "prowlarr";
    package = lib.mkPackageOption pkgs "prowlarr" { };

    dataDir = lib.mkOption {
      description = "Directory to store Prowlarr's data";
      type = lib.types.str;
      default = "/config";
    };
  };

  config = lib.mkIf cfg.enable {
    init.services.prowlarr = {
      enabled = true;

      script = pkgs.writeShellScript "prowlarr-run" ''
        ${lib.getExe cfg.package} \
          -nobrowser \
          -data=${cfg.dataDir}
      '';
    };
    
    environment.systemPackages = [ cfg.package ];
  };
}

{lib, config, pkgs, ...}:
let
  cfg = config.services.sonarr;
in
{
  options.services.sonarr = {
    enable = lib.mkEnableOption "sonarr";
    package = lib.mkPackageOption pkgs "sonarr" { };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/sonarr/.config/NzbDrone";
      description = "The directory where Sonarr stores its data files.";
    };
  };

  config = lib.mkIf cfg.enable {
    init.services.sonarr = {
      enabled = true;

      script = pkgs.writeShellScript "sonarr-run" ''
        ${lib.getExe cfg.package} -nobrowser -data=${cfg.dataDir}
      '';
    };

    environment.systemPackages = [ cfg.package ];
  };
}

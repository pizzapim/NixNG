{config, lib, pkgs, ...}:
let
  cfg = config.services.radarr;
in
{
  options.services.radarr = {
    enable = lib.mkEnableOption "radarr";
    package = lib.mkPackageOption pkgs "radarr" { };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/radarr/.config/Radarr";
      description = "The directory where Radarr stores its data files.";
    };
  };

  config = lib.mkIf cfg.enable {
    init.services.radarr = {
      enabled = true;

      script = pkgs.writeShellScript "radarr-run.sh" ''
        ${lib.getExe cfg.package} -nobrowser -data='${cfg.dataDir}'
      '';
    };

    environment.systemPackages = [cfg.package];
  };
}

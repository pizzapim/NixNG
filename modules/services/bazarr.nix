{
lib,
config,
pkgs,
...
}:
let
  cfg = config.services.bazarr;
in
{
  options.services.bazarr = {
    enable = lib.mkEnableOption "bazarr";
    package = lib.mkPackageOption pkgs "bazarr" { };

    configDir = lib.mkOption {
      description = "Where Bazarr's configuration files are stored.";
      type = lib.types.str;
      default = "/config";
    };
  };

  config = lib.mkIf cfg.enable {
    init.services.bazarr = {
      enabled = true;

      script = pkgs.writeShellScript "bazarr-run" ''
        ${lib.getExe cfg.package} \
          --no-update \
          --config '${cfg.configDir}'
      '';
    };

    environment.systemPackages = [ cfg.package ];
  };
}

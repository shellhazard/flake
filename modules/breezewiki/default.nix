{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.services.breezewiki;
in
{
  options = {
    services.breezewiki = {
      enable = mkEnableOption "breezewiki";
      config = mkOption {
        type = types.submodule {
          options = {
            bind_host = mkOption {
              type = types.str;
              description = "Which hostname to run the server on. The default value is auto. Auto means 127.0.0.1 in debug mode, otherwise, all interfaces. If you don’t know what this means, don’t change it.";
              default = "auto";
            };
            port = mkOption {
              type = types.int;
              description = "Which port to run the server on.";
              default = 10416;
            };
            canonical_origin = mkOption {
              type = types.str;
              description = "The primary URL where people can access the homepage of your instance.";
            };
            debug = mkOption {
              type = types.bool;
              description = "Enables debugging mode, for debugging BreezeWiki during development. Enables more runtime checks and more verbose output. Turns off some browser caching.";
              default = false;
            };
            feature_search_suggestions = mkOption {
              type = types.bool;
              description = "Enables the search suggestions feature. When enabled, any text typed in the search box will be sent to Fandom servers in order to provide suggestions. It will be sent via the proxy if the strict_proxy option is set.";
              default = true;
            };
            log_outgoing = mkOption {
              type = types.bool;
              description = "Whether to log outgoing requests to Fandom to the console.";
              default = true;
            };
            strict_proxy = mkOption {
              type = types.bool;
              description = "Whether to put more URLs through the proxy. If false, just a minimal set is proxied. If true, additionally proxies page stylesheets and links to image files, thereby reducing the potential for end-users to connect to Fandom servers.";
              default = true;
            };
          };
        };
      };
      package = mkOption {
        type = types.package;
        default = pkgs.callPackage ./breezewiki.nix { };
        description = "Package override.";
      };
    };
  };

  config = mkIf cfg.enable {
    # Create systemd service
    systemd.services."breezewiki" = {
      enable = true;
      description = "Breezewiki";
      wantedBy = [ "multi-user.target" ];
      environment = {
        BW_BIND_HOST = cfg.config.bind_host;
        BW_PORT = (builtins.toString cfg.config.port);
        BW_CANONICAL_ORIGIN = cfg.config.canonical_origin;
        BW_DEBUG = (builtins.toString cfg.config.debug);
        BW_FEATURE_SEARCH_SUGGESTIONS = (builtins.toString cfg.config.feature_search_suggestions);
        BW_LOG_OUTGOING = (builtins.toString cfg.config.log_outgoing);
        BW_STRICT_PROXY = (builtins.toString cfg.config.strict_proxy);
      };
      serviceConfig = {
        ExecStartPre = [
          "${pkgs.coreutils}/bin/mkdir -p /opt/breezewiki/bin"
          "${pkgs.coreutils}/bin/ln -sf ${cfg.package}/bin/breezewiki /opt/breezewiki/bin/breezewiki"
          "${pkgs.coreutils}/bin/ln -sf ${cfg.package}/lib /opt/breezewiki/lib"
        ];
        ExecStart = "/opt/breezewiki/bin/breezewiki";
        WorkingDirectory = "/opt/breezewiki/bin";
        ProtectHome = "read-only";
        Restart = lib.mkOverride 90 "always";
        RestartMaxDelaySec = lib.mkOverride 90 "1m";
        RestartSec = lib.mkOverride 90 "100ms";
        RestartSteps = lib.mkOverride 90 9;
        Type = "exec";
        DynamicUser = true;
      };
    };
  };

  # TODO: Apply config options through environment variables
  # TODO: Create systemd service
}

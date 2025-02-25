{
  lib,
}:
with import <nixpkgs> { };
let
  cfg = config.services.breezewiki;
in
callPackage ./breezewiki.nix {
  options = {
    services.breezewiki = {
      enable = mkEnableOption "Breezewiki";
      port = mkOption {
        type = types.int;
        description = "The port for the instance to bind to.";
        default = 8080;
      };
      config = types.submodule {
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
      package = mkOption {
        type = types.package;
        default = self.packages.${pkgs.system}.default;
        description = "Package override.";
      };
    };
  };

  config = mkIf cfg.enable {
    # Create systemd service
    systemd.services.breezewiki = {
      description = "Breezewiki";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/cmd -port ${toString cfg.port} -file ${
          builtins.toFile "config.yml" (lib.generators.toYAML { } (configToYAML cfg))
        }";
        ProtectHome = "read-only";
        Restart = "on-failure";
        Type = "exec";
        DynamicUser = true;
      };
    };
  };

  # TODO: Apply config options through environment variables
  # TODO: Create systemd service
}

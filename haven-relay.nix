{ config, lib, pkgs, ... }:

let
  cfg = config.services.haven-relay;

  # Import the .env file generation logic
  inherit (import ./haven-env.nix { inherit pkgs; }) mkEnvFile;
  # Build the Haven Relay package (example; adjust as needed)
  havenPackage = pkgs.buildGoModule {
    pname = "haven-relay";
    version = "0.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "bitvora";
      repo = "haven";
      rev = "b3a0dfb574275b58df2c05976a86af5bc822d7b6"; # Replace with a specific commit
      sha256 = "sha256-6tPbOz0Pgdi9grGpYx2uKjhEhe8nV0mSwCyOH35Bxpc="; # Replace with actual hash
    };
    vendorHash = "sha256-5d6C2sNG8aCaC+z+hyLgOiEPWP/NmAcRRbRVC4KuCEw=";

    # Copy templates directory into the output
    postInstall = ''
      mkdir -p $out/share/haven/templates
      install -D -m 644 $src/templates -t $out/share/haven/templates
    '';
  };
in {
  # Import options from haven-options.nix
  imports = [ ./haven-options.nix ];

  # Define the service configuration
  config = lib.mkIf (cfg != {}) {
    # Create directories for each instance
    systemd.tmpfiles.rules = lib.concatMap (name: [
      "d /var/lib/haven-relay/${name} 0755 haven-relay haven-relay -"
      "d /var/lib/haven-relay/${name}/templates 0755 haven-relay haven-relay -"
    ]) (lib.attrNames (lib.filterAttrs (n: v: v.enable) cfg));

    # Define systemd services
    systemd.services = lib.mapAttrs' (name: instanceCfg: {
      name = "haven-relay-${name}";
      value = lib.mkIf instanceCfg.enable {
        description = "Haven Relay instance for ${name}";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStartPre = [
            "${pkgs.coreutils}/bin/cp -r ${havenPackage}/share/haven/templates/* /var/lib/haven-relay/${name}/templates/"
            "${pkgs.coreutils}/bin/install -m 644 ${mkEnvFile name instanceCfg} /var/lib/haven-relay/${name}/.env"
            "${pkgs.coreutils}/bin/install -m 644 ${pkgs.writeText "haven-relay-${name}-import" (builtins.toJSON instanceCfg.importRelays)} /var/lib/haven-relay/${name}/relays_import.json"
            "${pkgs.coreutils}/bin/install -m 644 ${pkgs.writeText "haven-relay-${name}-blastr" (builtins.toJSON instanceCfg.blastrRelays)} /var/lib/haven-relay/${name}/relays_blastr.json"
          ];
          ExecStart = "${havenPackage}/bin/haven";
          WorkingDirectory = "/var/lib/haven-relay/${name}";
          Restart = "always";
          User = "haven-relay";
          Group = "haven-relay";
        };
      };
    }) cfg;

    # Open firewall ports
    networking.firewall.allowedTCPPorts = lib.concatMap
      (instanceCfg: [ instanceCfg.relayPort ])
      (lib.attrValues (lib.filterAttrs (n: v: v.enable) cfg));

    # Define system user and group
    users.users.haven-relay = {
      isSystemUser = true;
      group = "haven-relay";
    };
    users.groups.haven-relay = {};
  };
}

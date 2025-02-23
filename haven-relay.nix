{ config, lib, pkgs, ... }:

let
  cfg = config.services.haven-relay;

  # Import the .env file generation logic
  inherit (import ./haven-env.nix { inherit config lib pkgs; }) mkEnvFile;

  # Build the Haven Relay package (example; adjust as needed)
  havenPackage = pkgs.buildGoModule {
    pname = "haven-relay";
    version = "0.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "bitvora";
      repo = "haven";
      rev = "HEAD"; # Replace with a specific commit
      sha256 = lib.fakeSha256; # Replace with actual hash
    };
    vendorHash = null; # Replace after first build
  };
in {
  # Import options from haven-options.nix
  imports = [ ./haven-options.nix ];

  # Define the service configuration
  config = lib.mkIf (cfg != {}) {
    # Create directories for each instance
    systemd.tmpfiles.rules = lib.concatMap (name: [
      "d /var/lib/haven-relay/${name} 0755 haven-relay haven-relay -"
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
            "${pkgs.coreutils}/bin/install -m 644 ${mkEnvFile name instanceCfg} /var/lib/haven-relay/${name}/.env"
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

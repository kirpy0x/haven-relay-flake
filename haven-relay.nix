{ config, lib, pkgs, ... }:

let
  cfg = config.services.haven-relay;

  # Import the .env file generation logic
  inherit (import ./haven-env.nix { inherit pkgs; }) mkEnvFile;
  # Build the Haven Relay package
  havenPackage = pkgs.buildGoModule rec {
    pname = "haven-relay";
    version = "1.0.5";
    src = pkgs.fetchFromGitHub {
      owner = "bitvora";
      repo = "haven";
      rev = "v${version}";
      sha256 = "sha256-rSycrHW53TgqbsfgaRn3492EWtpu440GtbegozqnzMQ=";
    };
    vendorHash = "sha256-5d6C2sNG8aCaC+z+hyLgOiEPWP/NmAcRRbRVC4KuCEw=";

    # Copy templates directory into the output
    postInstall = ''
      mkdir -p $out/share/haven/
      cp -r $src/templates $out/share/haven/
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
            "${pkgs.coreutils}/bin/mkdir -p /var/lib/haven-relay/${name}"
            "+${pkgs.coreutils}/bin/ln -sfT ${havenPackage}/share/haven/templates /var/lib/haven-relay/${name}/templates"
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

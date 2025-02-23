# Haven-Relay-Flake

This is a Nixos flake to run [bitvora](https://github.com/bitvora)'s [HAVEN](https://github.com/bitvora/haven) (High Availability Vault for Events on Nostr). A personal relay for Nostr that includes 4 relays in one and a blossom server.

NOTE: I haven't tested the blossom server or backup options but i'd assume they'll work fine enough. the options below just set the values for the .env file.



Example input to your flake:
```
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    haven-relay.url = "https://github.com/kirpy0x/haven-relay-flake.git";
  };
  outputs =
    { nixpkgs, haven-relay, ... }:
  nixosConfigurations = {
    "host" = nixpkgs.lib.nixosSystem {
      modules = [
        haven-relay.nixosModules.haven-relay
      ];
    };
  };
```

Example usage/Required Options:
```
  services.haven-relay.user1 = {
    enable = true;
    ownerNpub = "npub1";
    importRelays = [
      "relay.damus.io"
      "nos.lol"
      "relay.nostr.band"
    ];
    blastrRelays = [
      "relay.damus.io"
      "nos.lol"
      "relay.nostr.band"
    ];
  };
  services.haven-relay.user2 = {
    enable = true;
    ownerNpub = "npub1";
    importRelays = [
      "relay.damus.io"
      "nos.lol"
      "relay.nostr.band"
    ];
    blastrRelays = [
      "relay.damus.io"
      "nos.lol"
      "relay.nostr.band"
    ];
  };
```

Additional options:
```
nix-repl> :p nixosConfigurations.host.config.services.haven-relay.user1
{
  enable = true;
  ownerNpub = "npub1xxx";
  relayBindAddress = "0.0.0.0";
  relayIcon = "";
  relayPort = 3355;
  relayUrl = "";
  blastrRelays = [
    "relay.damus.io"
    "nos.lol"
    "relay.nostr.band"
  ];
  importRelays = [
    "relay.damus.io"
    "nos.lol"
    "relay.nostr.band"
  ];
  dbEngine = "badger";
  importQueryIntervalSeconds = 600;
  importStartDate = "2023-01-20";
  lmdbMapsize = 0;
  limiters = {
    chat = {
      allowComplexFilters = false;
      allowEmptyFilters = false;
      connectionRateLimiterInterval = 3;
      connectionRateLimiterMaxTokens = 9;
      connectionRateLimiterTokensPerInterval = 3;
      eventIpLimiterInterval = 1;
      eventIpLimiterMaxTokens = 100;
      eventIpLimiterTokensPerInterval = 50;
      minimumFollowers = 1;
      wotDepth = 3;
      wotRefreshIntervalHours = 24;
    };
    inbox = {
      allowComplexFilters = false;
      allowEmptyFilters = false;
      connectionRateLimiterInterval = 1;
      connectionRateLimiterMaxTokens = 9;
      connectionRateLimiterTokensPerInterval = 3;
      eventIpLimiterInterval = 1;
      eventIpLimiterMaxTokens = 20;
      eventIpLimiterTokensPerInterval = 10;
      pullIntervalSeconds = 600;
    };
    outbox = {
      allowComplexFilters = false;
      allowEmptyFilters = false;
      connectionRateLimiterInterval = 1;
      connectionRateLimiterMaxTokens = 9;
      connectionRateLimiterTokensPerInterval = 3;
      eventIpLimiterInterval = 60;
      eventIpLimiterMaxTokens = 100;
      eventIpLimiterTokensPerInterval = 10;
    };
    private = {
      allowComplexFilters = true;
      allowEmptyFilters = true;
      connectionRateLimiterInterval = 5;
      connectionRateLimiterMaxTokens = 9;
      connectionRateLimiterTokensPerInterval = 3;
      eventIpLimiterInterval = 1;
      eventIpLimiterMaxTokens = 100;
      eventIpLimiterTokensPerInterval = 50;
    };
  };
  backup = {
    enable = false;
    intervalHours = 1;
    provider = "";
    s3 = {
      accessKeyId = "";
      bucketName = "backups";
      endpoint = "";
      region = "nyc3";
      secretKey = "";
    };
  };
}
```





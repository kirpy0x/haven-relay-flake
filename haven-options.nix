{ lib, ... }:

{
  options.services.haven-relay = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule ({ name, ... }: {
      options = {
        enable = lib.mkEnableOption "Haven Relay service";

        ownerNpub = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Owner's Nostr public key (npub).";
        };

        relayUrl = lib.mkOption {
          type = lib.types.str;
          default = "relay.utxo.one";
          description = "Relay URL.";
        };

        relayPort = lib.mkOption {
          type = lib.types.port;
          default = 3355;
          description = "Relay port.";
        };

        relayBindAddress = lib.mkOption {
          type = lib.types.str;
          default = "0.0.0.0";
          description = "Relay bind address.";
        };

        dbEngine = lib.mkOption {
          type = lib.types.enum [ "badger" "lmdb" ];
          default = "badger";
          description = "Database engine to use.";
        };

        lmdbMapsize = lib.mkOption {
          type = lib.types.int;
          default = 0;
          description = "LMDB map size.";
        };

        importRelays = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "List of import relays.";
        };

        blastrRelays = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "List of blastr relays.";
        };

        relayIcon = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "URL to relay icon for all relay types.";
        };

        importStartDate = lib.mkOption {
          type = lib.types.str;
          default = "2023-01-20";
          description = "Import start date.";
        };

        importQueryIntervalSeconds = lib.mkOption {
          type = lib.types.int;
          default = 600;
          description = "Import query interval in seconds.";
        };

        limiters = lib.mkOption {
          type = lib.types.submodule {
            options = {
              private = lib.mkOption {
                type = lib.types.submodule {
                  options = {
                    eventIpLimiterTokensPerInterval = lib.mkOption {
                      type = lib.types.int;
                      default = 50;
                      description = "Private relay event IP limiter tokens per interval.";
                    };
                    eventIpLimiterInterval = lib.mkOption {
                      type = lib.types.int;
                      default = 1;
                      description = "Private relay event IP limiter interval.";
                    };
                    eventIpLimiterMaxTokens = lib.mkOption {
                      type = lib.types.int;
                      default = 100;
                      description = "Private relay event IP limiter max tokens.";
                    };
                    allowEmptyFilters = lib.mkOption {
                      type = lib.types.bool;
                      default = true;
                      description = "Allow empty filters for private relay.";
                    };
                    allowComplexFilters = lib.mkOption {
                      type = lib.types.bool;
                      default = true;
                      description = "Allow complex filters for private relay.";
                    };
                    connectionRateLimiterTokensPerInterval = lib.mkOption {
                      type = lib.types.int;
                      default = 3;
                      description = "Private relay connection rate limiter tokens per interval.";
                    };
                    connectionRateLimiterInterval = lib.mkOption {
                      type = lib.types.int;
                      default = 5;
                      description = "Private relay connection rate limiter interval.";
                    };
                    connectionRateLimiterMaxTokens = lib.mkOption {
                      type = lib.types.int;
                      default = 9;
                      description = "Private relay connection rate limiter max tokens.";
                    };
                  };
                };
                default = {};
                description = "Rate limiters for private relay.";
              };

              chat = lib.mkOption {
                type = lib.types.submodule {
                  options = {
                    eventIpLimiterTokensPerInterval = lib.mkOption {
                      type = lib.types.int;
                      default = 50;
                      description = "Chat relay event IP limiter tokens per interval.";
                    };
                    eventIpLimiterInterval = lib.mkOption {
                      type = lib.types.int;
                      default = 1;
                      description = "Chat relay event IP limiter interval.";
                    };
                    eventIpLimiterMaxTokens = lib.mkOption {
                      type = lib.types.int;
                      default = 100;
                      description = "Chat relay event IP limiter max tokens.";
                    };
                    allowEmptyFilters = lib.mkOption {
                      type = lib.types.bool;
                      default = false;
                      description = "Allow empty filters for chat relay.";
                    };
                    allowComplexFilters = lib.mkOption {
                      type = lib.types.bool;
                      default = false;
                      description = "Allow complex filters for chat relay.";
                    };
                    connectionRateLimiterTokensPerInterval = lib.mkOption {
                      type = lib.types.int;
                      default = 3;
                      description = "Chat relay connection rate limiter tokens per interval.";
                    };
                    connectionRateLimiterInterval = lib.mkOption {
                      type = lib.types.int;
                      default = 3;
                      description = "Chat relay connection rate limiter interval.";
                    };
                    connectionRateLimiterMaxTokens = lib.mkOption {
                      type = lib.types.int;
                      default = 9;
                      description = "Chat relay connection rate limiter max tokens.";
                    };
                    wotDepth = lib.mkOption {
                      type = lib.types.int;
                      default = 3;
                      description = "Web of Trust depth for chat relay.";
                    };
                    wotRefreshIntervalHours = lib.mkOption {
                      type = lib.types.int;
                      default = 24;
                      description = "Web of Trust refresh interval in hours for chat relay.";
                    };
                    minimumFollowers = lib.mkOption {
                      type = lib.types.int;
                      default = 1;
                      description = "Minimum followers required for chat relay.";
                    };
                  };
                };
                default = {};
                description = "Rate limiters for chat relay.";
              };

              outbox = lib.mkOption {
                type = lib.types.submodule {
                  options = {
                    eventIpLimiterTokensPerInterval = lib.mkOption {
                      type = lib.types.int;
                      default = 10;
                      description = "Outbox relay event IP limiter tokens per interval.";
                    };
                    eventIpLimiterInterval = lib.mkOption {
                      type = lib.types.int;
                      default = 60;
                      description = "Outbox relay event IP limiter interval.";
                    };
                    eventIpLimiterMaxTokens = lib.mkOption {
                      type = lib.types.int;
                      default = 100;
                      description = "Outbox relay event IP limiter max tokens.";
                    };
                    allowEmptyFilters = lib.mkOption {
                      type = lib.types.bool;
                      default = false;
                      description = "Allow empty filters for outbox relay.";
                    };
                    allowComplexFilters = lib.mkOption {
                      type = lib.types.bool;
                      default = false;
                      description = "Allow complex filters for outbox relay.";
                    };
                    connectionRateLimiterTokensPerInterval = lib.mkOption {
                      type = lib.types.int;
                      default = 3;
                      description = "Outbox relay connection rate limiter tokens per interval.";
                    };
                    connectionRateLimiterInterval = lib.mkOption {
                      type = lib.types.int;
                      default = 1;
                      description = "Outbox relay connection rate limiter interval.";
                    };
                    connectionRateLimiterMaxTokens = lib.mkOption {
                      type = lib.types.int;
                      default = 9;
                      description = "Outbox relay connection rate limiter max tokens.";
                    };
                  };
                };
                default = {};
                description = "Rate limiters for outbox relay.";
              };

              inbox = lib.mkOption {
                type = lib.types.submodule {
                  options = {
                    eventIpLimiterTokensPerInterval = lib.mkOption {
                      type = lib.types.int;
                      default = 10;
                      description = "Inbox relay event IP limiter tokens per interval.";
                    };
                    eventIpLimiterInterval = lib.mkOption {
                      type = lib.types.int;
                      default = 1;
                      description = "Inbox relay event IP limiter interval.";
                    };
                    eventIpLimiterMaxTokens = lib.mkOption {
                      type = lib.types.int;
                      default = 20;
                      description = "Inbox relay event IP limiter max tokens.";
                    };
                    allowEmptyFilters = lib.mkOption {
                      type = lib.types.bool;
                      default = false;
                      description = "Allow empty filters for inbox relay.";
                    };
                    allowComplexFilters = lib.mkOption {
                      type = lib.types.bool;
                      default = false;
                      description = "Allow complex filters for inbox relay.";
                    };
                    connectionRateLimiterTokensPerInterval = lib.mkOption {
                      type = lib.types.int;
                      default = 3;
                      description = "Inbox relay connection rate limiter tokens per interval.";
                    };
                    connectionRateLimiterInterval = lib.mkOption {
                      type = lib.types.int;
                      default = 1;
                      description = "Inbox relay connection rate limiter interval.";
                    };
                    connectionRateLimiterMaxTokens = lib.mkOption {
                      type = lib.types.int;
                      default = 9;
                      description = "Inbox relay connection rate limiter max tokens.";
                    };
                    pullIntervalSeconds = lib.mkOption {
                      type = lib.types.int;
                      default = 600;
                      description = "Inbox relay pull interval in seconds.";
                    };
                  };
                };
                default = {};
                description = "Rate limiters for inbox relay.";
              };
            };
          };
          default = {};
          description = "Rate limiters for all relay types.";
        };

        backup = lib.mkOption {
          type = lib.types.submodule {
            options = {
              enable = lib.mkEnableOption "Backup service for Haven Relay";

              provider = lib.mkOption {
                type = lib.types.enum [ "none" "s3" ];
                default = "none";
                description = "Backup provider.";
              };

              intervalHours = lib.mkOption {
                type = lib.types.int;
                default = 1;
                description = "Backup interval in hours.";
              };

              s3 = lib.mkOption {
                type = lib.types.submodule {
                  options = {
                    accessKeyId = lib.mkOption {
                      type = lib.types.str;
                      default = "";
                      description = "S3 access key ID.";
                    };
                    secretKey = lib.mkOption {
                      type = lib.types.str;
                      default = "";
                      description = "S3 secret key.";
                    };
                    endpoint = lib.mkOption {
                      type = lib.types.str;
                      default = "";
                      description = "S3 endpoint.";
                    };
                    region = lib.mkOption {
                      type = lib.types.str;
                      default = "nyc3";
                      description = "S3 region.";
                    };
                    bucketName = lib.mkOption {
                      type = lib.types.str;
                      default = "backups";
                      description = "S3 bucket name.";
                    };
                  };
                };
                default = {};
                description = "S3 backup settings.";
              };
            };
          };
          default = {};
          description = "Backup settings for Haven Relay.";
        };
      };
    }));
    default = {};
    description = "Haven Relay service instances.";
  };
}

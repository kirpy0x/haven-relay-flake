{ pkgs, ... }:

let
  mkEnvFile = name: instanceCfg: pkgs.writeText "haven-relay-${name}-env" ''
    OWNER_NPUB=${instanceCfg.ownerNpub}
    RELAY_URL=${instanceCfg.relayUrl}
    RELAY_PORT=${toString instanceCfg.relayPort}
    RELAY_BIND_ADDRESS=${instanceCfg.relayBindAddress}
    DB_ENGINE=${instanceCfg.dbEngine}
    LMDB_MAPSIZE=${toString instanceCfg.lmdbMapsize}

    # Private Relay Settings
    PRIVATE_RELAY_NAME="${name}'s private relay"
    PRIVATE_RELAY_NPUB=${instanceCfg.ownerNpub}
    PRIVATE_RELAY_DESCRIPTION="A safe place to store my drafts and ecash"
    PRIVATE_RELAY_ICON=${instanceCfg.relayIcon}
    PRIVATE_RELAY_EVENT_IP_LIMITER_TOKENS_PER_INTERVAL=${toString instanceCfg.limiters.private.eventIpLimiterTokensPerInterval}
    PRIVATE_RELAY_EVENT_IP_LIMITER_INTERVAL=${toString instanceCfg.limiters.private.eventIpLimiterInterval}
    PRIVATE_RELAY_EVENT_IP_LIMITER_MAX_TOKENS=${toString instanceCfg.limiters.private.eventIpLimiterMaxTokens}
    PRIVATE_RELAY_ALLOW_EMPTY_FILTERS=${if instanceCfg.limiters.private.allowEmptyFilters then "true" else "false"}
    PRIVATE_RELAY_ALLOW_COMPLEX_FILTERS=${if instanceCfg.limiters.private.allowComplexFilters then "true" else "false"}
    PRIVATE_RELAY_CONNECTION_RATE_LIMITER_TOKENS_PER_INTERVAL=${toString instanceCfg.limiters.private.connectionRateLimiterTokensPerInterval}
    PRIVATE_RELAY_CONNECTION_RATE_LIMITER_INTERVAL=${toString instanceCfg.limiters.private.connectionRateLimiterInterval}
    PRIVATE_RELAY_CONNECTION_RATE_LIMITER_MAX_TOKENS=${toString instanceCfg.limiters.private.connectionRateLimiterMaxTokens}

    # Chat Relay Settings
    CHAT_RELAY_NAME="${name}'s chat relay"
    CHAT_RELAY_NPUB=${instanceCfg.ownerNpub}
    CHAT_RELAY_DESCRIPTION="A relay for private chats"
    CHAT_RELAY_ICON=${instanceCfg.relayIcon}
    CHAT_RELAY_WOT_DEPTH=${toString instanceCfg.limiters.chat.wotDepth}
    CHAT_RELAY_WOT_REFRESH_INTERVAL_HOURS=${toString instanceCfg.limiters.chat.wotRefreshIntervalHours}
    CHAT_RELAY_MINIMUM_FOLLOWERS=${toString instanceCfg.limiters.chat.minimumFollowers}
    CHAT_RELAY_EVENT_IP_LIMITER_TOKENS_PER_INTERVAL=${toString instanceCfg.limiters.chat.eventIpLimiterTokensPerInterval}
    CHAT_RELAY_EVENT_IP_LIMITER_INTERVAL=${toString instanceCfg.limiters.chat.eventIpLimiterInterval}
    CHAT_RELAY_EVENT_IP_LIMITER_MAX_TOKENS=${toString instanceCfg.limiters.chat.eventIpLimiterMaxTokens}
    CHAT_RELAY_ALLOW_EMPTY_FILTERS=${if instanceCfg.limiters.chat.allowEmptyFilters then "true" else "false"}
    CHAT_RELAY_ALLOW_COMPLEX_FILTERS=${if instanceCfg.limiters.chat.allowComplexFilters then "true" else "false"}
    CHAT_RELAY_CONNECTION_RATE_LIMITER_TOKENS_PER_INTERVAL=${toString instanceCfg.limiters.chat.connectionRateLimiterTokensPerInterval}
    CHAT_RELAY_CONNECTION_RATE_LIMITER_INTERVAL=${toString instanceCfg.limiters.chat.connectionRateLimiterInterval}
    CHAT_RELAY_CONNECTION_RATE_LIMITER_MAX_TOKENS=${toString instanceCfg.limiters.chat.connectionRateLimiterMaxTokens}

    # Outbox Relay Settings
    OUTBOX_RELAY_NAME="${name}'s outbox relay"
    OUTBOX_RELAY_NPUB=${instanceCfg.ownerNpub}
    OUTBOX_RELAY_DESCRIPTION="A relay and Blossom server for public messages and media"
    OUTBOX_RELAY_ICON=${instanceCfg.relayIcon}
    OUTBOX_RELAY_EVENT_IP_LIMITER_TOKENS_PER_INTERVAL=${toString instanceCfg.limiters.outbox.eventIpLimiterTokensPerInterval}
    OUTBOX_RELAY_EVENT_IP_LIMITER_INTERVAL=${toString instanceCfg.limiters.outbox.eventIpLimiterInterval}
    OUTBOX_RELAY_EVENT_IP_LIMITER_MAX_TOKENS=${toString instanceCfg.limiters.outbox.eventIpLimiterMaxTokens}
    OUTBOX_RELAY_ALLOW_EMPTY_FILTERS=${if instanceCfg.limiters.outbox.allowEmptyFilters then "true" else "false"}
    OUTBOX_RELAY_ALLOW_COMPLEX_FILTERS=${if instanceCfg.limiters.outbox.allowComplexFilters then "true" else "false"}
    OUTBOX_RELAY_CONNECTION_RATE_LIMITER_TOKENS_PER_INTERVAL=${toString instanceCfg.limiters.outbox.connectionRateLimiterTokensPerInterval}
    OUTBOX_RELAY_CONNECTION_RATE_LIMITER_INTERVAL=${toString instanceCfg.limiters.outbox.connectionRateLimiterInterval}
    OUTBOX_RELAY_CONNECTION_RATE_LIMITER_MAX_TOKENS=${toString instanceCfg.limiters.outbox.connectionRateLimiterMaxTokens}

    # Inbox Relay Settings
    INBOX_RELAY_NAME="${name}'s inbox relay"
    INBOX_RELAY_NPUB=${instanceCfg.ownerNpub}
    INBOX_RELAY_DESCRIPTION="Send your interactions with my notes here"
    INBOX_RELAY_ICON=${instanceCfg.relayIcon}
    INBOX_PULL_INTERVAL_SECONDS=${toString instanceCfg.limiters.inbox.pullIntervalSeconds}
    INBOX_RELAY_EVENT_IP_LIMITER_TOKENS_PER_INTERVAL=${toString instanceCfg.limiters.inbox.eventIpLimiterTokensPerInterval}
    INBOX_RELAY_EVENT_IP_LIMITER_INTERVAL=${toString instanceCfg.limiters.inbox.eventIpLimiterInterval}
    INBOX_RELAY_EVENT_IP_LIMITER_MAX_TOKENS=${toString instanceCfg.limiters.inbox.eventIpLimiterMaxTokens}
    INBOX_RELAY_ALLOW_EMPTY_FILTERS=${if instanceCfg.limiters.inbox.allowEmptyFilters then "true" else "false"}
    INBOX_RELAY_ALLOW_COMPLEX_FILTERS=${if instanceCfg.limiters.inbox.allowComplexFilters then "true" else "false"}
    INBOX_RELAY_CONNECTION_RATE_LIMITER_TOKENS_PER_INTERVAL=${toString instanceCfg.limiters.inbox.connectionRateLimiterTokensPerInterval}
    INBOX_RELAY_CONNECTION_RATE_LIMITER_INTERVAL=${toString instanceCfg.limiters.inbox.connectionRateLimiterInterval}
    INBOX_RELAY_CONNECTION_RATE_LIMITER_MAX_TOKENS=${toString instanceCfg.limiters.inbox.connectionRateLimiterMaxTokens}

    # Import Settings
    IMPORT_START_DATE=${instanceCfg.importStartDate}
    IMPORT_QUERY_INTERVAL_SECONDS=${toString instanceCfg.importQueryIntervalSeconds}
    # IMPORT_SEED_RELAYS_FILE="relays_import.json"
    IMPORT_SEED_RELAYS_FILE = "${pkgs.writeText "relays_import.json" ( builtins.toJSON instanceCfg.importRelays )}";

    # Blastr Settings
    # BLASTR_RELAYS_FILE="relays_blastr.json"
    BLASTR_RELAYS_FILE = "${pkgs.writeText "relays_blastr.json" (builtins.toJSON instanceCfg.blastrRelays)}";

    # Backup Settings
    BACKUP_PROVIDER=${instanceCfg.backup.provider}
    ${if instanceCfg.backup.enable then ''
      BACKUP_INTERVAL_HOURS=${toString instanceCfg.backup.intervalHours}
      ${if instanceCfg.backup.provider == "s3" then ''
        S3_ACCESS_KEY_ID=${instanceCfg.backup.s3.accessKeyId}
        S3_SECRET_KEY=${instanceCfg.backup.s3.secretKey}
        S3_ENDPOINT=${instanceCfg.backup.s3.endpoint}
        S3_REGION=${instanceCfg.backup.s3.region}
        S3_BUCKET_NAME=${instanceCfg.backup.s3.bucketName}
      '' else ""}
    '' else ""}
  '';
in {
  inherit mkEnvFile;
}

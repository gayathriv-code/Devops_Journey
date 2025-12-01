#!/usr/bin/env bash
# backup.sh - config-driven backup with retention and logging
set -euo pipefail
IFS=$'\n\t'

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$BASE_DIR/logs"
CFG_DIR="$BASE_DIR/config"
mkdir -p "$LOG_DIR" "$CFG_DIR"

LOG_FILE="$LOG_DIR/backup.log"
CONFIG_FILE="$CFG_DIR/backup.conf"
BACKUP_DIR_DEFAULT="$BASE_DIR/backups"

# Ensure a config file exists (safe defaults)
if [[ ! -f "$CONFIG_FILE" ]]; then
    cat > "$CONFIG_FILE" <<'EOF'
# backup.conf
# SOURCE: space-separated quoted path(s) or single path string
SOURCE="/home/ubuntu/hts-automation/logs"
DEST="$BASE_DIR/backups"
RETENTION_DAYS=7
EOF
fi

# Load config (allow expansion of $BASE_DIR)
# shellcheck disable=SC1090
eval "$(sed -n 's|$BASE_DIR|'"$BASE_DIR"'|g; p' "$CONFIG_FILE")"
# After eval, variables SOURCE, DEST, RETENTION_DAYS should be set (DEST uses expanded $BASE_DIR)

SOURCE="${SOURCE:-""}"
DEST="${DEST:-$BACKUP_DIR_DEFAULT}"
RETENTION_DAYS="${RETENTION_DAYS:-7}"

timestamp() { date +"%Y-%m-%d_%H-%M-%S"; }
log() { echo "[$(date +"%Y-%m-%d %H:%M:%S")] $*" | tee -a "$LOG_FILE"; }

# Validate source
if [[ -z "$SOURCE" ]]; then
    log "ERROR No SOURCE defined in $CONFIG_FILE"
    exit 1
fi

# create dest
mkdir -p "$DEST"

main() {
    for src in $SOURCE; do
        if [[ ! -e "$src" ]]; then
            log "ERROR Source $src does not exist; skipping."
            continue
        fi

        name=$(basename "$src")
        ts=$(timestamp)
        archive_name="${name}_backup_${ts}.tar.gz"
        archive_path="$DEST/$archive_name"

        log "INFO Creating backup of $src -> $archive_path"
        tar -czf "$archive_path" -C "$(dirname "$src")" "$name"

        # quick integrity check (list archive)
        if tar -tzf "$archive_path" >/dev/null 2>&1; then
            log "INFO Backup successful: $archive_path"
        else
            log "ERROR Backup archive appears corrupted: $archive_path"
            rm -f "$archive_path"
            continue
        fi
    done

    # Retention: remove archives older than RETENTION_DAYS
    log "INFO Cleaning backups older than $RETENTION_DAYS days in $DEST"
    find "$DEST" -type f -name '*_backup_*.tar.gz' -mtime +"$RETENTION_DAYS" -print -exec rm -f {} \;
    log "INFO Backup routine completed."
}

main


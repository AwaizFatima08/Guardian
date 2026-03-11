#!/bin/bash

set -e

PROJECT_DIR="$HOME/guardian"
BACKUP_ROOT="/NAS_BACKUPS/guardian_project_snapshots"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="$BACKUP_ROOT/guardian_snapshot_$TIMESTAMP"
MAX_BACKUPS=20

echo "========================================"
echo "Guardian Maintenance Script Started"
echo "Time: $(date)"
echo "========================================"

# Ensure project directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo "ERROR: Project directory $PROJECT_DIR not found."
    exit 1
fi

# Ensure NAS backup root exists
mkdir -p "$BACKUP_ROOT"

echo ""
echo "[1/6] Creating project snapshot backup on NAS..."

mkdir -p "$BACKUP_DIR"

rsync -av \
    --exclude='.git' \
    --exclude='logs/' \
    --exclude='raw/' \
    --exclude='*.log' \
    --exclude='*.pcap' \
    --exclude='__pycache__/' \
    --exclude='*.pyc' \
    "$PROJECT_DIR/" "$BACKUP_DIR/"

echo "Backup created at: $BACKUP_DIR"

echo ""
echo "[2/6] Moving to project directory..."
cd "$PROJECT_DIR"

echo ""
echo "[3/6] Checking git status..."
git status

echo ""
echo "Enter commit message:"
read -r COMMIT_MSG

if [ -z "$COMMIT_MSG" ]; then
    COMMIT_MSG="Routine Guardian update - $TIMESTAMP"
fi

echo ""
echo "[4/6] Adding and committing changes..."
git add .

if git diff --cached --quiet; then
    echo "No staged changes to commit."
else
    git commit -m "$COMMIT_MSG"
fi

echo ""
echo "[5/6] Pulling latest changes and pushing to GitHub..."
git pull --rebase origin main
git push origin main

echo ""
echo "[6/6] Cleaning old backups (keeping latest $MAX_BACKUPS)..."

cd "$BACKUP_ROOT"

ls -dt guardian_snapshot_* 2>/dev/null | tail -n +$((MAX_BACKUPS + 1)) | while read dir
do
    echo "Deleting old backup: $dir"
    rm -rf "$dir"
done

echo ""
echo "========================================"
echo "Guardian maintenance completed successfully."
echo "Backup location: $BACKUP_DIR"
echo "Finished: $(date)"
echo "========================================"


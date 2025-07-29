#!/bin/bash
set -e

[ -z "$S3_BACKUP_BUCKET" ] && exit 0

# Configure S3
export AWS_ENDPOINT_URL="$AWS_ENDPOINT"
S3_CMD="aws s3 --endpoint-url $AWS_ENDPOINT"

# Create backup
BACKUP_NAME="jenkins-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
tar -czf /tmp/$BACKUP_NAME \
    --exclude="$JENKINS_HOME/workspace" \
    --exclude="$JENKINS_HOME/caches" \
    --exclude="$JENKINS_HOME/logs" \
    -C $JENKINS_HOME .

# Upload
$S3_CMD cp /tmp/$BACKUP_NAME s3://$S3_BACKUP_BUCKET/
rm /tmp/$BACKUP_NAME

# Cleanup old backups (keep 7 days)
CUTOFF=$(date -d "7 days ago" +%Y%m%d)
$S3_CMD ls s3://$S3_BACKUP_BUCKET/ | grep jenkins-backup | while read -r line; do
    FILE=$(echo $line | awk '{print $4}')
    if [[ $FILE =~ jenkins-backup-([0-9]{8})- ]]; then
        [ "${BASH_REMATCH[1]}" -lt "$CUTOFF" ] && $S3_CMD rm s3://$S3_BACKUP_BUCKET/$FILE
    fi
done

echo "Backup complete: $BACKUP_NAME"
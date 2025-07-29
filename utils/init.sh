#!/bin/bash
set -e

echo "=== Jenkins Initialization ==="

# Configure AWS CLI for S3
aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
aws configure set region "$AWS_REGION"

# Set S3 endpoint for Zerops
export AWS_ENDPOINT_URL="$AWS_ENDPOINT"
S3_CMD="aws s3 --endpoint-url $AWS_ENDPOINT"


# Restore from backup if needed
echo "Checking for backups..."
LATEST_BACKUP=$($S3_CMD ls s3://$S3_BACKUP_BUCKET/ 2>/dev/null | grep jenkins-backup | sort | tail -n 1 | awk '{print $4}' || true)

if [ -n "$LATEST_BACKUP" ]; then
    echo "Restoring from: $LATEST_BACKUP"
    $S3_CMD cp s3://$S3_BACKUP_BUCKET/$LATEST_BACKUP /tmp/backup.tar.gz
    tar -xzf /tmp/backup.tar.gz -C $JENKINS_HOME
    rm /tmp/backup.tar.gz
fi

echo "=== Initialization Complete ==="
#!/bin/bash
set -e

sudo mkdir -p /var/jenkins
sudo chown zerops:zerops /var/jenkins

echo "=== Starting Jenkins Swarm Agent ==="
echo "Agent Name: $JENKINS_AGENT_NAME"
echo "Jenkins URL: $JENKINS_URL"

# Wait for Jenkins to be ready
while ! curl -s $JENKINS_URL/login > /dev/null; do
    echo "Waiting for Jenkins..."
    sleep 10
done

# Download Swarm client
SWARM_VERSION="3.50"
SWARM_JAR="/var/www/swarm-client.jar"

if [ ! -f "$SWARM_JAR" ]; then
    echo "Downloading Swarm client..."
    curl -fsSL https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${SWARM_VERSION}/swarm-client-${SWARM_VERSION}.jar -o $SWARM_JAR
fi

JENKINS_AGENT_NAME="${JENKINS_AGENT_GROUP_NAME}-${ZEROPS_Number}"

# Set executors based on CPU
EXECUTORS=${JENKINS_EXECUTORS:-2}

AGENT_WORKDIR=${JENKINS_AGENT_WORKDIR:-/var/www/jenkins/agent}

mkdir -p ${AGENT_WORKDIR}

# Start Swarm agent
echo "Starting Swarm agent with $EXECUTORS executors..."
exec java -jar $SWARM_JAR \
    -master $JENKINS_URL \
    -username ${JENKINS_ADMIN_ID:-admin} \
    -password ${JENKINS_ADMIN_PASSWORD} \
    -name "$JENKINS_AGENT_NAME" \
    -executors $EXECUTORS \
    -labels "${JENKINS_AGENT_LABELS:-linux zerops}" \
    -fsroot ${AGENT_WORKDIR} \
    -deleteExistingClients
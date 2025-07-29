#!/bin/bash
exec java -Djenkins.install.runSetupWizard=true \
          -jar /usr/share/java/jenkins.war \
          --httpPort=8080
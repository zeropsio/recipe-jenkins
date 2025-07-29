# Zerops x Jenkins

[Jenkins](https://jenkins.io) is a leading open-source automation server for continuous integration and continuous delivery (CI/CD). This setup provides a scalable Jenkins solution with distributed build agents for parallel job processing.

![Jenkins](https://www.jenkins.io/images/logos/jenkins/jenkins.svg)

<br/>

## Deploy on Zerops
You can either click the deploy button to deploy directly on Zerops, or manually copy the [import yaml](https://github.com/zeropsio/recipe-jenkins/blob/main/zerops-project-import.yml) to the import dialog in the Zerops app.

[![Deploy on Zerops](https://github.com/zeropsio/recipe-shared-assets/blob/main/deploy-button/green/deploy-button.svg)](https://app.zerops.io/recipe/jenkins)

<br/>

## Recipe features

- Jenkins running on **Zerops Java** service with auto-scaling
- Separate **jenkins agents** for parallel task processing with auto-scaling
- Zerops **Object Storage** (S3 compatible) service for Jenkins backups
- Logs set up to use **syslog** and accessible through Zerops GUI
- Utilization of Zerops built-in **environment variables** system
- [Mailpit](https://github.com/axllent/mailpit) as **SMTP mock server** for email testing

<br/>

## Changes made over the default installation

If you want to modify your existing Jenkins app to efficiently run on Zerops, these are the general steps we took:

- Add [zerops.yml](https://github.com/zeropsio/recipe-jenkins/blob/main/zerops.yml) to your repository, our example includes optimized build process and configuration for multiple workers
- Utilize Zerops [environment variables](https://github.com/zeropsio/recipe-jenkins/blob/main/zerops.yml#L53-L66) and [secrets](https://github.com/zeropsio/recipe-jenkins/blob/main/zerops-project-import.yml#L12-L14) to setup other services

<br/>
<br/>

Need help setting your project up? Join [Zerops Discord community](https://discord.com/invite/WDvCZ54).
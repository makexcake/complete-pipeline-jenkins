# Full demo pipeline 

The following repo is a demo project written by @makexcake while completing Tech World With Nana DevOps bootcamp exercises.

* java-mysql web app was provided by the course.

* In every chapter of the course more stages were added to the pipeline.

* Main branch contains the lastest working version.

* With every chapter more tools and stages will be added. 

## Description
The pipeline performs the following steps to the app provided by the course:

* increase app version before the buid
* build the application with gradle
* build docker image for the app and pushe it to ECR repository
* push the new version to git repository
* provision EKS cluster via Terraform 
* deploy required applications for the app (CSI driver, Mysql, Nginx controller) via helm chart
* deploy the app
* OPTIONAL STEP: destroy the infrustructure

## Preparations

The following tools are reqired to be installed and configured on Jenkins server:
* awscli
* helm
* kubectl
* (gettext-base)
* terraform


## Contributing

Tweaks,tricks comments and suggestions will be gladly appriciated.

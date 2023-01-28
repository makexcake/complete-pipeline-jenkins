pipeline {

    /*
        the pipeline uses the following apps installed on jenkins machine to word
        awscli
        helm
        kubectl
        envsubst (gettext-base)
        terraform
    */
    
    agent any

    parameters {
        booleanParam(name: 'skipDeploy', defaultValue: true, description: "true to skip")
        booleanParam(name: 'skipCommit', defaultValue: true, description: "true to skip")
        booleanParam(name: 'skipClusterProvision', defaultValue: false, description: "true to skip")
        booleanParam(name: 'skipClusterDestroy', defaultValue: true, description: "true to skip")
    }

    environment {
        DOCKER_REPO = '536167534320.dkr.ecr.eu-central-1.amazonaws.com/'
    }

    stages {

        //init stage
        stage('init') {
            steps {
                echo "initialising..." 
            }
        }

        //increase version
        stage('version increment') {
            steps {
                echo "increasing version..."

                script {
                    dir ('app') {
                        //change app version in build.gradle file
                        //call increase version script and export version to env vars
                        sh './increaseVersion.sh patch'
                        env.BUILD_VERSION = sh(returnStdout: true, script: "./readVersion.sh")
                        env.IMAGE_NAME = '''java-mysql-app:${BUILD_VERSION}'''                       
                    }
                }   
            }
        }



        //build
        stage('build app') {
            steps {
                echo "building app..."     
                
                //build app according to instructions
                script {
                    dir ('app') {
                        sh './gradlew build'   
                    }                   
                }               
            }
        }


        //test
        stage('test') {
            steps {
                echo "testing..."
            }
        }


        //build image and push to repo
        stage('build image') {
            steps {
                echo "pushing to ecr"
                
                script {

                    dir ('app') {
                        sh "aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 536167534320.dkr.ecr.eu-central-1.amazonaws.com"
                        sh "docker build -t ${IMAGE_NAME} . --build-arg appver=${BUILD_VERSION}"
                        sh "docker tag ${IMAGE_NAME} 536167534320.dkr.ecr.eu-central-1.amazonaws.com/${IMAGE_NAME}"
                        sh "docker push 536167534320.dkr.ecr.eu-central-1.amazonaws.com/${IMAGE_NAME}"                       
                    }
                }
            }
        }


        //commit version update in git repo
        stage('commit') {

            when {
                expression {
                    params.skipCommit == false
                }
            }

            steps {
                echo "comitting to git..."

                script {
                    withCredentials([usernamePassword(credentialsId: 'github-tok', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        
                        //NOTE: add ignore commiter strategy plugin to avoid build and push loops
                        sh 'git config --global user.name "jenkins"'
                        sh 'git config --global user.email "jenkins@example.com"'

                        sh 'git status'
                        sh 'git branch'
                        sh 'git config --list'
                        
                        //NOTE: use auth token instead of password
                        sh "git remote set-url origin https://${USER}:${PASS}@github.com/makexcake/java-mysql-pipeline.git"
                        sh "git add ."
                        sh 'git commit -m "auto version bump"'
                        sh 'git push origin HEAD:main'
                    }
                }
                
            }
        }


        //provision an infrustructure for app deployment using terraform
        stage ('provision cluster') {
            when {
                expression {
                    params.skipClusterProvision == false
                }
            }

            steps {
               echo "provisioning EKS cluster" 

               script {
                    dir ('terraform') {
                        sh 'terraform init'
                        sh 'terraform plan'
                        sh 'terraform apply -auto-approve'
                    }
               }
            }           
        }


        //destroy cluster if the parameter is true
        stage ('destroy cluster') {
            when {
                expression {
                    params.skipClusterDestroy == false
                }
            }

            steps {
                echo "destroying cluster"
            }
        }


        //deploy app on the EKS cluster
        stage('deploy') {

            when {
                expression {
                    params.skipDeploy == false
                }
            }

            steps {
                echo "deploying on EKS..."

                script {
                    //set app version in helm chart using envsubst 
                    sh "envsubst < templates/java-app-values-template.txt > helm/java-app-values/my-java-app-values.yaml"

                    //deploy app with app helm chart
                    dir ('helm') {
                        sh 'helm install -f java-app-values/my-java-app-values.yaml my-java-app my-java-app/'
                    }                    
                }
            }
        }
    } 
}
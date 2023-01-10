pipeline {

    agent any
    tools {
        //NOTE: must have node plugin installed
        nodejs "node"
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
                    //call increase version script and export version to env vars
                    sh './increaseVersion.sh patch'
                    env.BUILD_VERSION = sh(returnStdout: true, script: "./readVersion.sh")
                    env.IMAGE_NAME = "java-mysql-app:${BUILD_VERSION}"
                }   
            }
        }
        

        //build
        stage('build app') {
            steps {
                echo "building app..."     

                script {
                    sh './gradlew build'
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

                    sh "envsubst < Dockerfile"
                    
                    withCredentials([usernamePassword(credentialsId: 'aws-ecr', passwordVariable: 'PASSWORD', usernameVariable: 'USER')]) {
                        
                        sh "echo $PASSWORD | docker login -u $USER --password-stdin 536167534320.dkr.ecr.eu-central-1.amazonaws.com"
                        sh "docker build -t java-mysql-app ."
                        sh "docker tag java-mysql-app:${BUILD_VERSION} 536167534320.dkr.ecr.eu-central-1.amazonaws.com/java-mysql-app:${BUILD_VERSION}"
                        sh "docker push 536167534320.dkr.ecr.eu-central-1.amazonaws.com/java-mysql-app:${BUILD_VERSION}"
                    }
                }
            }
        }


        //commit version update in git repo
        stage('commit') {
            steps {
                echo "comitting to git..."
                
            }
        }
    } 
}
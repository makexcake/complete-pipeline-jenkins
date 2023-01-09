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
                    //call version increment script
                    sh './increaseVersion.sh patch'
                    //sh './readVersion.sh'
                    env.BUILD_VERSION = sh(returnStdout: true, script: "./readVersion.sh")
                    echo "this is the build version: ${BUILD_VERSION}"
                    env.IMAGE_NAME = "makecake/bootcamp-java-mysql:${BUILD_VERSION}"
                    echo "this is the image name: ${IMAGE_NAME}"
                }   
            }
        }
        

        //build
        stage('build') {
            steps {
                echo "building and pushing to repo..."     

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


        //commit version update in git repo
        stage('commit') {
            steps {
                echo "comitting to git..."
                
            }
        }
    } 
}
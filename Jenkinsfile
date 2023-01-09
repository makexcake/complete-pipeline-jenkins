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
                    sh "./increaseVersion.sh patch"
                    env.BUILD_VERSION = ${sh "sed -n 8p build.gradle | awk '{print $2}' | xargs | echo"}
                }   
                echo ${BUILD_VERSION}             
            }
        }

        //test
        stage('test') {
            steps {
                echo "testing..."
            }
        }

        //build
        stage('build') {
            steps {
                echo "building and pushing to repo..."                    
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
#!/usr/bin/env groovy
//@Library('jenkins-shared-lib') ---this will not work since we remove the global git variable

library identifier: 'jenkins-shared-lib@main', retriever: modernSCM(
        [$class: 'GitSCMSource',
         remote: 'https://github.com/hussainsheriffC/jenkins-shared-lib.git',
         credentialsId: 'github-credentials'
        ]
)

pipeline {
    agent any
    tools {
        maven 'maven-3.9'
    }
    environment {
        IMAGE_NAME = 'hussainsheriffj/demo-app:java-maven-1.0'
    }
    stages {
        stage('build app') {
            steps {
                script {
                    echo "building application jar"
                    buildJar()
                }
            }
        }
        stage('build image') {
            steps {
                script {
                    echo "building docker image..."
                    buildImage(env.IMAGE_NAME)
                    dockerLogin()
                    dockerPush(env.IMAGE_NAME)
                }
            }
        }
        stage("deploy") {
            steps {
                script {
                    echo 'deploying docker images to ec2'
                    def dockerCmd = 'docker run -p 8081:8081 -d hussainsheriffj/demo-app:java-maven-1.0'
                    sshagent(['ec2-server-key']) {
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@3.110.214.134 ${dockerCmd}"
                    }
                }
            }
        }
    }   
}

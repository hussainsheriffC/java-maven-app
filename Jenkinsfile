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
        stage('provision server'){
            environment {
                AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
                TF_VAR_env_prefix = 'test'
            }
            steps {
                script{
                    dir('terraform'){
                        sh "terraform init"
                        sh "terraform apply --auto-approve"
                        EC2_PUBLIC_IP = sh (
                            script: "terraform output ec2-public-ip",
                            returnStdout: true
                        ).trim()
                    }
                }
            }
        }        
        stage("deploy") {
            steps {
                script {
                    echo "waiting for ec2 server to initialize"
                    sleep(time: 90, unit: "SECONDS")
                    echo 'deploying docker images to ec2'
                    echo "${EC2_PUBLIC_IP}"

                    def shellCmd = "bash ./server-cmds.sh ${IMAGE_NAME}"
                    def ec2Instance = "ec2-user@${EC2_PUBLIC_IP}"

                    sshagent(['server-ssh-key']) {
                        sh "scp -o StrictHostKeyChecking=no server-cmds.sh ${ec2Instance}:/home/ec2-user"
                        sh "scp -o StrictHostKeyChecking=no docker-compose.yaml ${ec2Instance}:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} ${shellCmd}"
                    }
                }
            }
        }
    }   
}
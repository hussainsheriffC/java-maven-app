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
    
    stages {
        stage('increment version'){
            steps {
                script {    //here we are incrementing the build
                    echo 'incrementing app version...'
                    sh 'mvn build-helper:parse-version versions:set \
                        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                        versions:commit'
                    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
                    env.IMAGE_NAME = "$version-$BUILD_NUMBER"
                }
            }
        }
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
        stage('deploy') {
            steps {
                script {
                    echo 'deploying docker images to ec2...'

                    def shellCmd = "bash ./server-cmds.sh ${IMAGE_NAME}"
                    def ec2Instance = "ec2-user@13.233.199.177"    //change this ip according to ip add.
                    sshagent(['ec2-server-key']) {
                        sh "scp -o StrictHostKeyChecking=no server-cmds.sh ${ec2Instance}:/home/ec2-user"
                        sh "scp docker-compose.yaml ${ec2Instance}:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} ${shellCmd}"
                    }
                }
            }
        }
        stage('commit version update') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'github-credentials', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh 'git config --global user.email "hussain.sheriff@cloudreach.com"'
                        sh 'git config --global user.name "jenkins"'
                        
                        sh 'git status'
                        sh 'git branch'
                        sh 'git config --list'
                        
                        sh "git remote set-url origin https://${USER}:${PASS}@github.com/hussainsheriffC/java-maven-app.git"
                        sh 'git add .'
                        sh 'git commit -m "ci: version pump"'
                        sh 'git push origin HEAD:jenkins-jobs'
                    }
                }
            }
        }
    }   
}

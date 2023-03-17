#!/usr/bin/env groovy
//@Library('jenkins-shared-lib') ---this will not work since we remove the global git variable

library identifier: 'jenkins-shared-lib@main', retriever: modernSCM(
        [$class: 'GitSCMSource',
         remote: 'https://github.com/hussainsheriffC/jenkins-shared-lib.git',
         credentialsId: 'github-credentials'
        ]
)


def gv

pipeline {
    agent any
    tools {
        maven 'maven-3.9'
    }
    stages {
        stage("init") {
            steps {
                script{
                    gv = load "script.groovy"
                }
            }
        }
        stage("build jar") {
            steps {
                script {
                    buildJar()
                }
            }
        }

        stage("build and push image") {
            steps {
                script {
                    buildImage 'hussainsheriffj/demo-app:jma-2.2'
                    dockerLogin()
                    dockerPush 'hussainsheriffj/demo-app:jma-2.2'
                }
            }
        }
        
    
        stage("deploy") {
            steps {
                script {
                    gv.deployApp()
                }
            }
        }
    }   
}
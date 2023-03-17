#!/usr/bin/env groovy
@Library('jenkins-shared-lib')
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
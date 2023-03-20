#!/usr/bin/env groovy

pipeline {
    agent any
    stages {
        stage("test") {
            steps {
                script {
                    echo "Testing the application..."
                }
            }
        }
        stage("build") {
            steps {
                script {
                    echo "building the application"
                    //gv.buildJar()
                }
            }
        }
        stage("deploy") {
            steps {
                script {
                    echo "deploying the application..."
                    //gv.deployApp()
                }
            }
        }
    }   
}

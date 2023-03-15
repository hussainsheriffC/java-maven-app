#!/usr/bin/env groovy

def gv

pipeline {
    agent any
    parameters{
        choice(name: 'VERSION', choices: ['1.1.0', '1.2.0', '1.3.0'], description: '')
        booleanParam(name: 'executeTests', defaultValue: true, description: '')
    }

    stages {
        stage("init"){
            steps{
                script {
                    gv = load "script.groovy"
                }
            }
        }
    }
    stages {
        stage("build") {
            steps {
                //echo 'Building the application...'
                script{
                    gv.buildApp()
                }
            }
        }
        stage("test") {
            when {
                expression {
                    params.executeTests
                }
            }
            steps {
                //echo 'Testing the application...'
                script{
                    gv.testApp()
                }
                
            }
        }
        stage("deploy") {
            steps {
                    //echo 'Deploying the application...'
                    //echo "deploying version ${params.VERSION}"
                    script{
                    gv.deployApp()
                }
            }
        }
    }
}

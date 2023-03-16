//def gv

pipeline {
    agent none
    stages {
        stage("test") {
            steps {
                script {
                    echo "Testing the application..."
                    echo "Executing pipeline for branch $BRANCH_NAME"
                }
            }
        }

        stage("build") {
            //similar to if else jenkins will have when
            when {
                expression {
                    BRANCH_NAME == 'main'
                }
            }
            steps {
                script {
                    echo "Building the application..."
                }
            }
        }
        
    
        stage("deploy") {
            when {
                expression {
                    BRANCH_NAME == 'main'
                }
            }
            steps {
                script {
                    echo "Deploying the application..."
                }
            }
        }
    }   
}
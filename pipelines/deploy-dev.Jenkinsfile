pipeline {
    agent {
        label 'general'
    }

    parameters {
        string(name: 'SERVICE_NAME', defaultValue: '', description: '')
        string(name: 'IMAGE_FULL_NAME_PARAM', defaultValue: '', description: '')
    }

    stages {
        stage('Git setup') {
            steps {
                sh 'git checkout -b dev || git checkout dev'
            }
        }
        stage('update YAML manifest') {
            steps {
                sh '''
                    cd k8s/${SERVICE_NAME}
                    git config user.email "you@example.com"
                    git config user.name "Your Name"
                    sed -i "s|image: .*|image: ${IMAGE_FULL_NAME_PARAM}|" deployment.yaml
                    git add "deployment.yaml"
                    git commit -m "Jenkins deploy $SERVICE_NAME $IMAGE_FULL_NAME_PARAM"
                '''
            }
        }
        stage('Git push') {
            steps {
               withCredentials([usernamePassword(credentialsId: 'github_personal_access_token', usernameVariable: 'GITHUB_USERNAME', passwordVariable: 'GITHUB_TOKEN')]) {
                 sh '''
                 git push https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/Yaelwil/PolybotInfra dev
                 '''
               }
            }
        }
    }
    post {
        cleanup {
            cleanWs()
        }
    }
}
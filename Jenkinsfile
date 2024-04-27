pipeline {
     environment {
       ID_DOCKER = "${ID_DOCKER_PARAMS}"
       IMAGE_NAME = "website-karma"
       IMAGE_TAG = "latest"
          //       PORT_EXPOSED = "80" à paraméter dans le job
       STAGING = "${ID_DOCKER}-karma-staging"
       PRODUCTION = "${ID_DOCKER}-production"
     }
     agent none
     stages {
         stage('Build image') {
             agent any
             steps {
                script {
                  sh 'docker build -t ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_TAG .'
                }
             }
        }
        stage('Run container based on builded image') {
            agent any
            steps {
               script {
                 sh '''
                    echo "Clean Environment"
                    docker rm -f $IMAGE_NAME || echo "container does not exist"
                    docker run --name $IMAGE_NAME -d -p ${PORT_EXPOSED}:5000 -e PORT=5000 ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_TAG
                    sleep 5
                 '''
               }
            }
       }
              stage('Test image') {
           agent any
           steps {
              script {
                sh '''
                    curl localhost:${PORT_EXPOSED}
                '''
              }
           }
      }
      stage('Clean Container') {
          agent any
          steps {
             script {
               sh '''
                 docker stop $IMAGE_NAME
                 docker rm $IMAGE_NAME
               '''
             }
          }
     }

          stage ('Login and Push Image on docker hub') {
          agent any
        environment {
           DOCKERHUB_PASSWORD  = credentials('dockerhub')
        }            
          steps {
             script {
               sh '''
                   echo $DOCKERHUB_PASSWORD_PSW | docker login -u $ID_DOCKER --password-stdin
                   docker push ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_TAG
               '''
             }
          }
      }    
     
      stage('Push image in staging and deploy it') {
    when {
        expression { GIT_BRANCH == 'origin/main' }
    }
    agent any
    environment {
        HEROKU_API_KEY = credentials('heroku_api_key')
    }  
    steps {
        script {
            sh '''
                 sh 'node --version'
                     sh 'npm --version'
      sh 'npm i -g heroku'
  
      sh 'HEROKU_API_KEY=${HEROKU_API_KEY} heroku container:login --no-logs'
                heroku create $STAGING || echo "project already exist"
                heroku container:push -a $STAGING web
                heroku container:release -a $STAGING web
            '''
        }
    }
}
  }
    post {
        always {
            emailext (
                attachLog: true,
                from: 'lionelkomguemalma@gmail.com',
                to: 'lionel77350@gmail.com',
                subject: "Rapport de build - ${currentBuild.fullDisplayName}",
                body: "Bonjour,\n\nLe build ${currentBuild.fullDisplayName} s'est terminé avec le statut ${currentBuild.currentResult}.\n\nCordialement,\nJenkins",
            )
        }
    }
}

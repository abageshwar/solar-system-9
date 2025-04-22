pipeline {
  agent any

   environment {
    NAME = "solar-system-9"
    VERSION = "${env.BUILD_ID}-${env.GIT_COMMIT}"
    IMAGE_REPO = "abagesh1904"
    GIT_TOKEN = credentials('git-creds')
  }
  
  stages {
    stage('Unit Tests') {
      steps {
        echo 'Implement unit tests if applicable.'
        echo 'This stage is a sample placeholder'
      }
    }

    stage('Build Image') {
      steps {
             sh "docker build -t ${NAME} ."
            sh "docker tag ${NAME}:latest ${IMAGE_REPO}/${NAME}:${VERSION}"
        }
      }

stage('Push Image') {
  steps {
    script {
      withDockerRegistry([credentialsId: "docker-creds", url: ""]) {
        sh "docker push ${IMAGE_REPO}/${NAME}:${VERSION}"
      }
    }
  }
}

    
    stage('Clone/Pull Repo') {
      steps {
        script {
          if (fileExists('gitops-argocd')) {

            echo 'Cloned repo already exists - Pulling latest changes'

            dir("gitops-argocd") {
            }

          } else {
            echo 'Repo does not exists - Cloning the repo'
            sh 'git clone -b feature-gitea http://$GIT_TOKEN@github.com/abageshwar/gitops-argocd'
          }
        }
      }
    }

    stage('Update Manifest') {
      steps {
        dir("gitops-argocd/jenkins-demo") {
          sh 'ls -la'
          sh 'pwd'
          sh 'cd gitops-argocd/jenkins-demo'
          sh 'ls -la'
          sh 'sed -i "s#abagesh1904.*#${IMAGE_REPO}/${NAME}:${VERSION}#g" deployment.yaml'
          sh 'cat deployment.yaml'
        }
      }
    }

    stage('Commit & Push') {
      steps {
        dir("gitops-argocd/jenkins-demo") {
          sh "git config --global user.email 'jenkins@ci.com'"
          sh 'git remote set-url origin http://$GIT_TOKEN@github.com/abageshwar/gitops-argocd'
          sh 'git checkout feature-gitea'
          sh 'git add -A'
          sh 'git commit -am "Updated image version for Build - $VERSION"'
          sh 'git push origin feature-gitea'
        }
      }
    }

    stage('Raise PR') {
      steps {
        sh "bash pr.sh"
      }
    } 
  }
}

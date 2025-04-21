pipeline {
  agent any


        kubernetes {
            yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: docker
spec:
  containers:
    - name: jnlp
      image: jenkins/inbound-agent
      args: ['\$(JENKINS_SECRET)', '\$(JENKINS_NAME)']
    - name: docker
      image: docker:20.10.24
      command:
        - cat
      tty: true
      volumeMounts:
        - name: docker-graph-storage
          mountPath: /var/lib/docker
  volumes:
    - name: docker-graph-storage
      emptyDir: {}
"""
            defaultContainer 'docker'
        }
    }


  environment {
    NAME = "solar-system"
    VERSION = "${env.BUILD_ID}-${env.GIT_COMMIT}"
    IMAGE_REPO = "siddharth67"
    GITEA_TOKEN = credentials('my-git-creds')
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
        withDockerRegistry([credentialsId: "docker-hub", url: ""]) {
          sh 'docker push ${IMAGE_REPO}/${NAME}:${VERSION}'
        }
      }
    }

    
    stage('Update Manifest') {
      steps {
        dir("gitops-argocd/jenkins-demo") {
          sh 'sed -i "s#siddharth67.*#${IMAGE_REPO}/${NAME}:${VERSION}#g" deployment.yaml'
          sh 'cat deployment.yaml'
        }
      }
    }

    stage('Commit & Push') {
      steps {
        dir("gitops-argocd/jenkins-demo") {
          sh "git config --global user.email 'jenkins@ci.com'"
          sh 'git remote set-url origin http://$GITEA_TOKEN@139.59.21.103:3000/siddharth/gitops-argocd'
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

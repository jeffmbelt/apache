pipeline {
  agent { label "agentfarm" }
  stages {
    stage('Delete the workspace') {
      steps {
        sh "sudo rm -rf $WORKSPACE/*"
      }
    }
    stage('Second Stage') {
      steps {
        echo 'Second stage'
      }
    }
    stage('Third Stage') {
      steps {
        echo 'Third stage'
      }
    }
  }
}

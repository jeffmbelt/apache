pipeline {
  agent { label "agentfarm" }
  stages {
    stage('Delete the workspace') {
      steps {
        sh "sudo rm -rf $WORKSPACE/*"
      }
    }
    stage("Installing Chef Workstation") {
      steps {
        script {
          def exists = fileExists '/usr/bin/chef-client'
          if (exists) {
            echo "Skipping Chef Workstation Install"
          } else {
            echo "Installing Chef Workstation"
            sh 'sudo apt-get install -y wget tree unzip'
            sh 'wget https://packages.chef.io/files/stable/chef-workstation/0.15.6/ubuntu/18.04/chef-workstation_0.15.6-1_amd64.deb'
            sh 'sudo dpkg -i chef-workstation_0.15.6-1_amd64.deb'
            sh 'sudo chef env --chef-license accept'
          }
        }
      }
    }
    stage('Install Test Kitchen Gem') {
      steps {
       script {
          def exists = fileExists '/opt/chef-workstation/embedded/lib/ruby/gems/2.6.0/gems/test-kitchen-2.3.3/bin/kitchen'
          if (exists) {
            echo "Skipping Kitchen Gem Install"
          } else {
            echo "Installing Test Kitchen"
            sh 'sudo chef gem install kitchen-docker'
            sh 'sudo chef env --chef-license accept'
          }
      }
    }
    stage('Download Apache Cookbook') {
      steps {
        git credentialsId: 'git-repo-id', url: 'git@github.com:jeffmbelt/apache.git'
      }
    }
    stage('Run Kitchen Destroy') {
      steps {
            sh 'sudo kitchen destroy'
      }
    }
    stage('Run Kitchen Create') {
      steps {
            sh 'sudo kitchen create'
      }
    }
    stage('Run Kitchen Converge') {
      steps {
            sh 'sudo kitchen converge'
      }
    }
    stage('Run Kitchen Verify') {
      steps {
            sh 'sudo kitchen verify'
      }
    }
    stage('Kitchen Destroy') {
      steps {
            sh 'sudo kitchen destroy'
      }
    }
  }
}

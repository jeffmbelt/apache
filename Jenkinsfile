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
    stage('Send Slack Notification') {
      steps {
         slackSend color: 'YELLOW', message: "Mr. Belt: Please approve ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.JOB_URL} | Open>)"
      }
    }
    stage('Request Input') {
      steps {
         input 'Please approve or deny this build'
      }
    }
    stage('Upload to Chef Infra Server, Converge Nodes') {
      steps {
        withCredentials([zip(credentialsId: 'chef-starter-zip', variable: 'CHEFREPO')]) {
          sh "chef install $WORKSPACE/Policyfile.rb -c $CHEFREPO/chef-repo/.chef/knife.rb"
          sh "sudo chef push prod $WORKSPACE/Policyfile.lock.json -c $CHEFREPO/chef-repo/.chef/knife.rb"
          withCredentials([sshUserPrivateKey(credentialsId: 'agent-key', keyFileVariable: 'agentKey', passphraseVariable: '', usernameVariable: '')]) { 
           sh "knife ssh 'policy_name:apache' -x ubuntu -i $agentKey 'sudo chef-client' -c $CHEFREPO/chef-repo/.chef/knife.rb"
          } 
        }
      }
    }
  }
  post {
     success {
       slackSend color: 'GREEN', message: "Build $JOB_NAME $BUILD_NUMBER Successful!"
     }
     failure {
       slackSend color: 'RED', message: "Build $JOB_NAME $BUILD_NUMBER Failed!"
     }
    }
}

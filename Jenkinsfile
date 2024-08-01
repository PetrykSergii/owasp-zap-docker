pipeline {
    agent any

    stages {
        stage('SCM') {
            steps {
                git branch: 'dev', changelog: false, credentialsId: 'jenkins', poll: false, url: 'git@github.com:renthous-kyiv-ua/backend.git'
            }
        }
        stage('Dependenc check') {
            steps {
                dependencyCheck additionalArguments: '--format HTML', odcInstallation: 'DP-Check'
            }
        }
    }
}

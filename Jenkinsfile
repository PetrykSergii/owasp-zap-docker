pipeline {
    agent any

    environment {
        ZAP_IMAGE = 'dependency-check-custom'
        CLONE_DIR = '/owasp-zap-docker'
    }

    stages {
        stage('Prepare Directory') {
            steps {
                sh '''
                    mkdir -p ${CLONE_DIR}
                    chown -R jenkins:jenkins ${CLONE_DIR}
                    rm -rf ${CLONE_DIR}/*
                '''
            }
        }
        stage('Clone repository') {
            steps {
                dir("${CLONE_DIR}") {
                    git url: 'https://github.com/PetrykSergii/owasp-zap-docker.git', branch: 'main'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    dir("${CLONE_DIR}") {
                        docker.build("${ZAP_IMAGE}", ".")
                    }
                }
            }
        }
        stage('Run OWASP Dependency-Check') {
            steps {
                script {
                    docker.image("${ZAP_IMAGE}").inside('-u 0:0 --entrypoint=""') {
                        sh '''
                            echo "Starting OWASP Dependency-Check"
                            /entrypoint.sh
                            echo "Moving report to workspace"
                            mv /owasp-zap-docker/dependency-check-report.html ${WORKSPACE}/dependency-check-report.html || true
                        '''
                    }
                }
            }
        }
        stage('Publish Report') {
            steps {
                script {
                    if (fileExists('dependency-check-report.html')) {
                        echo 'Report found, publishing...'
                        publishHTML target: [
                            reportName: 'Dependency-Check Report',
                            reportDir: '.',
                            reportFiles: 'dependency-check-report.html',
                            alwaysLinkToLastBuild: true,
                            keepAll: true
                        ]
                    } else {
                        echo 'No report found to publish.'
                    }
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}

pipeline {
    agent any

    environment {
        ZAP_IMAGE = 'dependency-check-custom'
        WEB_APP_URL = 'https://renthous.kyiv.ua/'
        CLONE_DIR = '/var/lib/jenkins/owasp-zap-docker'
    }

    stages {
        stage('Prepare Directory') {
            steps {
                // Создание папки, установка прав и удаление старых файлов
                sh '''
                    mkdir -p ${CLONE_DIR}
                    chown -R jenkins:jenkins ${CLONE_DIR}
                    rm -rf ${CLONE_DIR}/*
                '''
            }
        }
        stage('Clone repository') {
            steps {
                // Клонируем репозиторий в указанную папку
                dir("${CLONE_DIR}") {
                    git url: 'https://github.com/PetrykSergii/owasp-zap-docker.git', branch: 'main'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Строим Docker-образ из склонированного репозитория
                    dir("${CLONE_DIR}") {
                        docker.build("${ZAP_IMAGE}", ".")
                    }
                }
            }
        }
        stage('Run OWASP Dependency-Check') {
            steps {
                script {
                    // Запуск Docker-контейнера с OWASP Dependency-Check и выполнение сканирования
                    docker.image("${ZAP_IMAGE}").inside('-u 0:0') {
                        sh '''
                            # Запуск OWASP Dependency-Check и сканирование зависимостей
                            dependency-check/bin/dependency-check.sh --project "MyProject" --scan /path/to/project || true
                            # Создание отчета
                            mv /path/to/project/dependency-check-report.html ${WORKSPACE}/dependency-check-report.html || true
                        '''
                    }
                }
            }
        }
        stage('Publish Report') {
            steps {
                // Публикация отчета OWASP Dependency-Check
                publishHTML (target: [
                    reportName: 'Dependency-Check Report',
                    reportDir: '.',
                    reportFiles: 'dependency-check-report.html',
                    alwaysLinkToLastBuild: true,
                    keepAll: true
                ])
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}

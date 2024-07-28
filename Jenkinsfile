pipeline {
    agent any

    environment {
        ZAP_IMAGE = 'owasp/dependency-check'
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
        stage('Pull Docker Image') {
            steps {
                script {
                    // Проверяем наличие образа перед сборкой
                    sh 'docker pull owasp/dependency-check'
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
                    docker.image("${ZAP_IMAGE}").inside {
                        sh '''
                            cd ${CLONE_DIR}
                            # Запуск OWASP Dependency-Check и сканирование зависимостей
                            dependency-check.sh --project "MyProject" --scan /path/to/project
                            # Создание отчета
                            mv /path/to/project/dependency-check-report.html ${WORKSPACE}/dependency-check-report.html
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

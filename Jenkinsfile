pipeline {
    agent any

    environment {
        ZAP_IMAGE = 'owasp-zap-docker'
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
        stage('Run OWASP ZAP') {
            steps {
                script {
                    // Запуск Docker-контейнера с OWASP ZAP и выполнение сканирования
                    docker.image("${ZAP_IMAGE}").inside {
                        sh '''
                            cd ${CLONE_DIR}
                            # Запуск OWASP ZAP и сканирование веб-приложения
                            zap.sh -daemon -config api.disablekey=true -port 8090
                            zap-cli quick-scan --self-contained --start-options '-config api.disablekey=true' ${WEB_APP_URL}
                            zap-cli report -o zap_report.html -f html

                            # Сохранение отчета как артефакт
                            mv zap_report.html ${WORKSPACE}/zap_report.html
                        '''
                    }
                }
            }
        }
        stage('Publish Report') {
            steps {
                // Публикация отчета OWASP ZAP
                publishHTML (target: [
                    reportName: 'ZAP Report',
                    reportDir: '.',
                    reportFiles: 'zap_report.html',
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

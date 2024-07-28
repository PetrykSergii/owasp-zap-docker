pipeline {
    agent any

    environment {
        ZAP_IMAGE = 'owasp-zap-docker'
        WEB_APP_URL = 'https://renthous.kyiv.ua/'
    }

    stages {
        stage('Clone repository') {
            steps {
                // Клонируем репозиторий
                git 'https://github.com/PetrykSergii/owasp-zap-docker.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Строим Docker-образ из клонированного репозитория
                    docker.build("${ZAP_IMAGE}", ".")
                }
            }
        }
        stage('Run OWASP ZAP') {
            steps {
                script {
                    // Запуск Docker-контейнера с OWASP ZAP и выполнение сканирования
                    docker.image("${ZAP_IMAGE}").inside {
                        sh '''
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

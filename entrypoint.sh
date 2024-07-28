#!/bin/bash

# Проверка содержимого директории
ls -l /owasp-zap-docker

# Проверка существования директории и файлов
if [ ! -f /owasp-zap-docker/dependency-check/bin/dependency-check.sh ]; then
    echo "dependency-check.sh не найден в /owasp-zap-docker/dependency-check/bin/"
    exit 1
fi

if [ ! -d /path/to/project ]; then
    echo "/path/to/project директория не существует, создаю..."
    mkdir -p /path/to/project
fi

# Запуск OWASP Dependency-Check и сканирование зависимостей
/owasp-zap-docker/dependency-check/bin/dependency-check.sh --project "MyProject" --scan /path/to/project

# Проверка наличия отчета
if [ -f /path/to/project/dependency-check-report.html ]; then
    # Сохранение отчета как артефакт
    mv /path/to/project/dependency-check-report.html /owasp-zap-docker/dependency-check-report.html
else
    echo "Отчет не найден, сканирование могло завершиться неудачно."
    exit 1
fi




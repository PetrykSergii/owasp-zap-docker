#!/bin/bash

# Запуск OWASP Dependency-Check и сканирование зависимостей
dependency-check/bin/dependency-check.sh --project "MyProject" --scan /path/to/project

# Сохранение отчета как артефакт
mv /path/to/project/dependency-check-report.html /workspace/dependency-check-report.html


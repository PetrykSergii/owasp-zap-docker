#!/bin/bash

# Запуск ZAP в режиме командной строки с тестовым планом
zap.sh -daemon -config api.disablekey=true -port 8090
zap-cli quick-scan --self-contained --start-options '-config api.disablekey=true' https://renthous.kyiv.ua
zap-cli report -o zap_report.html -f html

# Удаление ZAP
zap-cli shutdown

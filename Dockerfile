# Используем официальный образ OWASP ZAP
FROM owasp/zap2docker-stable

# Устанавливаем зависимости (если нужно)
RUN apt-get update && apt-get install -y \
    curl \
    jq

# Копируем скрипты и конфигурации (если есть)
COPY entrypoint.sh /entrypoint.sh

# Устанавливаем права на выполнение скрипта
RUN chmod +x /entrypoint.sh

# Указываем точку входа
ENTRYPOINT ["/entrypoint.sh"]

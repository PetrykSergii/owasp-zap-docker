# Используем образ OpenJDK
FROM openjdk:11-jre-slim

# Устанавливаем зависимости
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    unzip

# Устанавливаем OWASP Dependency-Check
RUN curl -L https://github.com/jeremylong/DependencyCheck/releases/download/v6.5.2/dependency-check-6.5.2-release.zip -o dependency-check.zip && \
    unzip dependency-check.zip && \
    rm dependency-check.zip && \
    mv dependency-check /usr/local/bin/dependency-check

# Копируем скрипты и конфигурации (если есть)
COPY entrypoint.sh /entrypoint.sh

# Устанавливаем права на выполнение скрипта
RUN chmod +x /entrypoint.sh

# Указываем точку входа
ENTRYPOINT ["/entrypoint.sh"]




# --- Этап 1: Сборка приложения ---
# Используем официальный образ Gradle с JDK 17
FROM gradle:8.5-jdk17-alpine AS build

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /home/gradle/project

# Копируем файлы сборки для загрузки зависимостей (это кэшируется Docker'ом)
COPY build.gradle.kts settings.gradle.kts gradlew ./
COPY gradle ./gradle

# Копируем исходный код
COPY src ./src

# Собираем приложение. `shadowJar` используется для создания "fat JAR" со всеми зависимостями.
# Убедитесь, что у вас подключен плагин 'shadow' в build.gradle.kts
# Если вы используете другой плагин (например, Spring Boot), команда может быть `build` или `bootJar`.
RUN ./gradlew shadowJar --no-daemon

# --- Этап 2: Создание финального образа ---
# Используем минимальный образ с Java Runtime
FROM openjdk:17-jre-slim

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем JAR-файл из этапа сборки
# Путь к JAR может отличаться в зависимости от настроек вашего build.gradle.kts
COPY --from=build /home/gradle/project/build/libs/EchoTelegramBot-1.0-SNAPSHOT-all.jar app.jar

# Указываем команду для запуска приложения
ENTRYPOINT ["java", "-jar", "app.jar"]
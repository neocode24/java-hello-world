# 1단계: Build Stage
FROM gradle:8.7-jdk17 AS build
WORKDIR /app

# 의존성 캐시 최적화를 위해 먼저 복사
COPY build.gradle settings.gradle gradle.properties ./
COPY gradle gradle
RUN gradle --no-daemon dependencies || true

# 전체 소스 복사 및 빌드
COPY . .
RUN ./gradlew build --no-daemon

# 2단계: Runtime Stage
FROM eclipse-temurin:17-jre
WORKDIR /app

# 빌드한 JAR 복사
COPY --from=build /app/build/libs/*.jar app.jar

# 애플리케이션 실행
ENTRYPOINT ["java", "-jar", "app.jar"]

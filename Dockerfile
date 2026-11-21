# ── Stage 1: Build ───────────────────────────────────────────────────────────
FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /workspace

# Copy Maven wrapper first (better layer caching)
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
COPY src src

# Download deps (cached layer), then package skipping tests
RUN --mount=type=cache,target=/root/.m2 \
    chmod +x mvnw && ./mvnw -ntp -B package -DskipTests

# ── Stage 2: Runtime ─────────────────────────────────────────────────────────
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Non-root user for security
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

COPY --from=build /workspace/target/*.war app.war

EXPOSE 8080

# Railway injects PORT env var — pass it to Spring Boot
ENTRYPOINT ["java", \
  "-Djava.security.egd=file:/dev/./urandom", \
  "-Dserver.port=${PORT:-8080}", \
  "-jar", "app.war"]

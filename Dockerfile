# ====== Stage 1: Build ======
FROM eclipse-temurin:25-jdk AS build

ARG DB_TO_USE
RUN case "$DB_TO_USE" in \
        h2|postgres|mysql|mariadb) \
            echo "✅ Building with profile: $DB_TO_USE" ;; \
        *) \
            echo "❌ ERROR: Invalid DB_TO_USE '$DB_TO_USE'"; \
            echo "📋 Valid options: h2, postgres, mysql, mariadb"; \
            exit 1 ;; \
    esac

WORKDIR /app
COPY . .
RUN chmod +x ./mvnw
RUN ./mvnw clean package -q -DskipTests=true -P ${DB_TO_USE}

# ====== Stage 2: Runtime ======
FROM eclipse-temurin:25-jre

ARG APP_VERSION=

ARG DB_TO_USE
ENV SPRING_PROFILES_ACTIVE=${DB_TO_USE}

ARG SERVER_PORT=8080
EXPOSE ${SERVER_PORT}

COPY --from=build /app/target/spring-boot-multi-db-*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
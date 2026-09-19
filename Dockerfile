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

ARG MAVEN_CLI_OPTS="-B -q"

RUN chmod +x ./mvnw
RUN ./mvnw $MAVEN_CLI_OPTS clean package -DskipTests=true -P ${DB_TO_USE}

# ====== Stage 2: Runtime ======
FROM eclipse-temurin:25-jre

# Install curl, needed by the docker compose healthcheck
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

ARG DB_TO_USE
ENV SPRING_PROFILES_ACTIVE=${DB_TO_USE}

ARG SERVER_PORT=8080
ENV SERVER_PORT=${SERVER_PORT}
EXPOSE ${SERVER_PORT}

COPY --from=build /app/target/ishtech-springboot-multi-db-*.jar ishtech-springboot-multi-db.jar

ENTRYPOINT ["java", "-jar", "ishtech-springboot-multi-db.jar"]

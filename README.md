# springboot-multi-db
Spring Boot example with connecting to different DB by passing DB name as profile

- java - 25
- spring-boot - 3.5.7
- Docker

## Databases
- H2
- MariaDB
- MySQL
- PostgreSQL

## Run

### Run with docker-compose

```
docker-compose -f docker-compose-h2.yml       stop && SERVER_PORT=8181               docker-compose -f docker-compose-h2.yml       up --build && open http://localhost:8181/about

docker-compose -f docker-compose-mysql.yml    stop && SERVER_PORT=8282 DB_PORT=13306 docker-compose -f docker-compose-mysql.yml    up --build && open http://localhost:8282/about

docker-compose -f docker-compose-mariadb.yml  stop && SERVER_PORT=8383 DB_PORT=23306 docker-compose -f docker-compose-mariadb.yml  up --build && open http://localhost:8383/about

docker-compose -f docker-compose-postgres.yml stop && SERVER_PORT=8484 DB_PORT=15432 docker-compose -f docker-compose-postgres.yml up --build && open http://localhost:8484/about

```
### Run with local db and local build

#### DB / Tables

- H2
    - No need of set up


- MariaDB / MySQL
    - Connect to MariaDB
        - `mariadb -u multidbuser -pmultidbpass -D multidb`
    - Connect to MySQL
        - `mysql -u multidbuser -pmultidbpass -D multidb`

```
-- DROP DATABASE IF EXISTS `multidb`;
CREATE DATABASE IF NOT EXISTS `multidb`
DEFAULT CHARACTER SET = utf8mb4
DEFAULT COLLATE = utf8mb4_unicode_ci
;

-- DROP USER IF EXISTS `multidbuser`@`%`;
CREATE USER IF NOT EXISTS `multidbuser`@`%`
IDENTIFIED BY 'multidbpass'
;

GRANT CREATE, REFERENCES, INDEX, ALTER, LOCK TABLES ON `multidb`.* TO `multidbuser`@`%`;
GRANT SELECT, INSERT, UPDATE ON `multidb`.* TO `multidbuser`@`%`;


FLUSH PRIVILEGES;
```

- PostgreSQL

```
psql -U multidbuser -W -d multidb

CREATE DATABASE multidb;

CREATE USER multidbuser WITH PASSWORD 'multidbpass';

GRANT ALL PRIVILEGES ON DATABASE multidb TO multidbuser;

\c multidb

GRANT USAGE, CREATE ON SCHEMA public TO multidbuser;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO multidbuser;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO multidbuser;
```

#### Junit

- Need
    - JDK25 or higher
    - Docker

- Test

```
./mvnw test -P h2       -Dspring.profiles.active=h2
./mvnw test -P mariadb  -Dspring.profiles.active=mariadb
./mvnw test -P mysql    -Dspring.profiles.active=mysql
./mvnw test -P postgres -Dspring.profiles.active=postgres

```

- Run
    - Ensure the port, db properties are correct in application-xxx.properties / application-xxx.yml

```
./mvnw spring-boot:run -P h2       -Dspring-boot.run.profiles=h2
./mvnw spring-boot:run -P mariadb  -Dspring-boot.run.profiles=mariadb
./mvnw spring-boot:run -P mysql    -Dspring-boot.run.profiles=mysql
./mvnw spring-boot:run -P postgres -Dspring-boot.run.profiles=postgres

```

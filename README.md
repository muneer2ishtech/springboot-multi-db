# springboot-multi-db
Spring Boot example with connecting to different DB by passing DB name as profile

## Tech stack
- Java: 25
- Spring Boot: 4.0.x
- Containerization: Docker

### Databases
- H2
- MariaDB
- MySQL
- PostgreSQL

##

[GIT](https://github.com/muneer2ishtech/springboot-multi-db)


## DB

- I have customized docker for various databases
    - See [https://github.com/IshTech/docker-db](https://github.com/IshTech/docker-db)

#### H2
- No need of set up


#### MariaDB / MySQL

- Login to DB as `root` and run [init_db_mysql.sql](src/test/resources/db/init_db_mysql.sql) to setup DB Schema, DB User and Grant privileges

- Connect to MariaDB
    - `mariadb -u multidbuser -pmultidbpass -D multidb`
- Connect to MySQL
    - `mysql -u multidbuser -pmultidbpass -D multidb`


#### PostgreSQL

- Login to DB as `root` / `superuser` and run [init_db_postgres.sql](src/test/resources/db/init_db_postgres.sql) to setup DB Schema, DB User and Grant privileges

- Connect to PostgreSQL
    - `psql -U multidbuser -W -d multidb`
    - Enter password on prompt `multidbpass`


## Build and Run

### Maven

#### Junit Test

- Local or Docker instance of DB should be running

```
./mvnw test -P h2       -Dspring.profiles.active=h2
./mvnw test -P mariadb  -Dspring.profiles.active=mariadb
./mvnw test -P mysql    -Dspring.profiles.active=mysql
./mvnw test -P postgres -Dspring.profiles.active=postgres

```

#### Local Maven Run

- Ensure the port, db properties are correct in application-xxx.properties / application-xxx.yml

```
./mvnw spring-boot:run -P h2       -Dspring-boot.run.profiles=h2
./mvnw spring-boot:run -P mariadb  -Dspring-boot.run.profiles=mariadb
./mvnw spring-boot:run -P mysql    -Dspring-boot.run.profiles=mysql
./mvnw spring-boot:run -P postgres -Dspring-boot.run.profiles=postgres

```

### Docker

#### Run with docker compose

- Each database has its own compose file: `docker-compose-h2.yml`, `docker-compose-mysql.yml`, `docker-compose-mariadb.yml` and `docker-compose-postgres.yml`
    - Each compose file builds the application image for its database
    - The MySQL, MariaDB and PostgreSQL compose files also start their own database container, so no local database is needed
- You can run any or all of them simultaneously, as long as each one uses different ports
- Below args are optional, you can change to desired value or skip, if skipped they will use default value
    - `SERVER_PORT` port the spring-boot app runs on, both inside the container and on the host machine, if skipped defaults to `8080`
    - `SERVER_PORT_H2`, `SERVER_PORT_MYSQL`, `SERVER_PORT_MARIADB`, `SERVER_PORT_POSTGRES` same as `SERVER_PORT`, but for one database only, if skipped falls back to `SERVER_PORT`. Use these when running several databases at once
    - `DB_PORT` port the database is exposed on, on the host machine (not used by H2), if skipped defaults to `3306` for MySQL and MariaDB, and `5432` for PostgreSQL
    - `DB_PORT_MYSQL`, `DB_PORT_MARIADB`, `DB_PORT_POSTGRES` same as `DB_PORT`, but for one database only, if skipped falls back to `DB_PORT`. Use these when running several databases at once
    - `APP_VERSION` is the prefix of the built image's tag, as `muneer2ishtech/ishtech-springboot-multidb-app:$APP_VERSION-<db>`, for example `muneer2ishtech/ishtech-springboot-multidb-app:3.1.0-SNAPSHOT-h2`, if skipped the image is tagged with the database name alone, for example `muneer2ishtech/ishtech-springboot-multidb-app:h2`
- Suggested: append `-local` to `APP_VERSION` when building locally, so a locally built image is not confused with, and does not overwrite, the same tag pulled from Docker Hub. The tag then reads, for example, `muneer2ishtech/ishtech-springboot-multidb-app:3.1.0-SNAPSHOT-local-h2`

##### Individually

```
export APP_VERSION=$(./mvnw help:evaluate -Dexpression=project.version -q -DforceStdout 2>/dev/null)
echo $APP_VERSION

SERVER_PORT=8181               APP_VERSION=$APP_VERSION docker compose -f docker-compose-h2.yml       up --build

SERVER_PORT=8282 DB_PORT=13306 APP_VERSION=$APP_VERSION docker compose -f docker-compose-mysql.yml    up --build

SERVER_PORT=8383 DB_PORT=23306 APP_VERSION=$APP_VERSION docker compose -f docker-compose-mariadb.yml  up --build

SERVER_PORT=8484 DB_PORT=55432 APP_VERSION=$APP_VERSION docker compose -f docker-compose-postgres.yml up --build

```

##### All at once

```
export APP_VERSION=$(./mvnw help:evaluate -Dexpression=project.version -q -DforceStdout 2>/dev/null)
echo $APP_VERSION

SERVER_PORT_H2=8181 \
SERVER_PORT_MYSQL=8282 DB_PORT_MYSQL=13306 \
SERVER_PORT_MARIADB=8383 DB_PORT_MARIADB=23306 \
SERVER_PORT_POSTGRES=8484 DB_PORT_POSTGRES=55432 \
APP_VERSION=$APP_VERSION \
docker compose \
  -f docker-compose-h2.yml \
  -f docker-compose-mysql.yml \
  -f docker-compose-mariadb.yml \
  -f docker-compose-postgres.yml \
up \
--build

```

##### Same, tagging the locally built image with a `-local` suffix

- In the commands above, replace the first line, `export APP_VERSION=...`, with the line below

```
export APP_VERSION=$(./mvnw help:evaluate -Dexpression=project.version -q -DforceStdout 2>/dev/null)-local

```

##### Stop and remove

- Run these in a separate terminal, or after stopping the running `up` with `Ctrl+C`
- Use the same compose files as for `up`: one `-f` for a single database, or all four `-f` for "All at once". The examples below use H2 for a single database
- To stop, keeping the containers, the database data and the images

```
docker compose -f docker-compose-h2.yml stop

```

- To stop and remove the containers, the database data (volumes) and the built application image
    - Set `APP_VERSION` to the same value as for `up`, because the name of the image to remove is built from it
    - The pulled database image (for example `mariadb:lts`) is kept

```
APP_VERSION=$APP_VERSION docker compose -f docker-compose-h2.yml down -v --rmi local

APP_VERSION=$APP_VERSION \
docker compose \
  -f docker-compose-h2.yml \
  -f docker-compose-mysql.yml \
  -f docker-compose-mariadb.yml \
  -f docker-compose-postgres.yml \
down -v --rmi local

```


### Test

- H2
    - <http://localhost:8181/about>


- MariaDB
    - <http://localhost:8383/about>


- MySQL
    - <http://localhost:8282/about>


- PostgreSQL
    - <http://localhost:8484/about>

```
start http://localhost:8181/about
start http://localhost:8282/about
start http://localhost:8383/about
start http://localhost:8484/about
```

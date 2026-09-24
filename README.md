# springboot-multi-db
Spring Boot example with connecting to different DB by passing DB name as profile

## Tech stack

- JDK 25 (default)
- Other supported JDK versions:
  - JDK 21
  - JDK 17
- Spring Boot: 4.0.x
- Containerization: Docker

### Databases
- H2
- MariaDB
- MySQL
- PostgreSQL

### Application version for each JDK version

- Releases for the default JDK version have plain version numbers, for example `x.y.z`. They are built from the branches `dev` and `main`.
- Releases for another supported JDK version have the same version number with the suffix `-jdkNN`, for example `x.y.z-jdk21` for JDK 21. They are built from the branch `dev-jdkNN`, for example `dev-jdk21`, from the same code, adapted where that JDK version needs it.
- Each release is published as the Docker image `muneer2ishtech/ishtech-springboot-multidb-app` on Docker Hub, with one tag for each database: the version followed by `-h2`, `-postgres`, `-mysql` or `-mariadb`, for example `x.y.z-postgres` or `x.y.z-jdk21-postgres`.

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

- You can change port numbers as per your choice and availability
- You can run any or all of below simulantenously

##### Individually

```
export APP_VERSION=$(./mvnw help:evaluate -Dexpression=project.version -q -DforceStdout 2>/dev/null)
echo $APP_VERSION

SERVER_PORT=8181               APP_VERSION=$APP_VERSION docker-compose -f docker-compose-h2.yml       up --build

SERVER_PORT=8282 DB_PORT=13306 APP_VERSION=$APP_VERSION docker-compose -f docker-compose-mysql.yml    up --build

SERVER_PORT=8383 DB_PORT=23306 APP_VERSION=$APP_VERSION docker-compose -f docker-compose-mariadb.yml  up --build

SERVER_PORT=8484 DB_PORT=55432 APP_VERSION=$APP_VERSION docker-compose -f docker-compose-postgres.yml up --build

```

#### All at once

```
export APP_VERSION=$(./mvnw help:evaluate -Dexpression=project.version -q -DforceStdout 2>/dev/null)
echo $APP_VERSION

SERVER_PORT_H2=8181 \
SERVER_PORT_MYSQL=8282 DB_PORT_MYSQL=13306 \
SERVER_PORT_MARIADB=8383 DB_PORT_MARIADB=23306 \
SERVER_PORT_POSTGRES=8484 DB_PORT_POSTGRES=55432 \
APP_VERSION=$APP_VERSION \
docker-compose \
  -f docker-compose-h2.yml \
  -f docker-compose-mysql.yml \
  -f docker-compose-mariadb.yml \
  -f docker-compose-postgres.yml \
up \
--build

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

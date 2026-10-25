# Known Issues

Known issues that have been confirmed by testing but not yet fixed. Each entry has enough detail to reproduce and fix without re-investigating.

---

## 1. A GitHub release with a JDK-variant tag (`vx.y.z-jdkNN`) doesn't publish a Docker image

**Status:** Open. Recorded in full in springboot-books-app: [`KNOWN-ISSUES.md`, issue 1](https://github.com/muneer2ishtech/springboot-books-app/blob/dev/KNOWN-ISSUES.md).
**Impact:** Medium — a JDK-variant release publishes no Docker image, and nothing fails visibly.
**Affects:** `.github/workflows/cicd.yml`, trigger `on.push.tags: ['v[0-9]+.[0-9]+.[0-9]+']`, the same as in springboot-books-app.

The description, steps to reproduce, likely cause and suggested fix are in the linked entry; apply the same fix here, and verify it as described there, with this repo's image.

---

## 2. `GET /about` shows the wrong `version` when the app runs with `spring-boot:run`

**Status:** Open
**Impact:** Low — `/about` reports the version of a dependency instead of the application's version, but only with `./mvnw spring-boot:run` (README, section "Build and Run", subsection "Local Maven Run"). With the packaged jar, as in docker compose, the version is correct.
**Affects:** `HomeController.appVersion()`, used by `GET /about`, with every database profile.

### Description

`appVersion()` reads `Implementation-Version` from the manifest returned by `SpringBootMultiDbApplication.class.getResourceAsStream("/META-INF/MANIFEST.MF")`. With an absolute path, this returns the first `META-INF/MANIFEST.MF` on the classpath. In the packaged jar that is the application's own manifest. With `spring-boot:run`, the application's classes are in `target/classes`, which has no manifest, so the first manifest found belongs to a dependency jar.

### Steps to reproduce

1. Run the app with any profile, for example `./mvnw spring-boot:run -P h2 -Dspring-boot.run.profiles=h2`.
2. `GET http://localhost:8080/about`.

Expected: `"version":"3.1.0-SNAPSHOT"`, the `<version>` in `pom.xml`.
Actual: `"version":"1.5.38"`. Seen with the `h2`, `mariadb` and `postgres` profiles. With docker compose, `/about` correctly shows `"version":"3.1.0-SNAPSHOT"`.

### Likely cause

`getResourceAsStream` with an absolute path finds the first manifest on the classpath, not the manifest of the application's own jar.

### Suggested fix

Get the version from Spring Boot's build information instead of the manifest: add the `build-info` goal to `spring-boot-maven-plugin` and inject `BuildProperties` (`buildProperties.getVersion()`). It works both with `spring-boot:run` and with the packaged jar. `SpringBootMultiDbApplication.class.getPackage().getImplementationVersion()` is simpler, but returns `null` with `spring-boot:run`.

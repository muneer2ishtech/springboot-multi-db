<!-- Repo-specific instructions. The shared IshTech rules live in .claude/rules/ and are identical across repos; don't put repo-specific content there. -->
# springboot-multi-db

The owner's standing instructions are in `.claude/rules/` (`owner-workflow.md`, `git-and-branches.md`, `versions-and-releases.md`, `build-and-test.md`, `build-tooling.md`, `documentation.md`, `repositories.md`). They apply to every task in this repo. This file adds only what is specific to this repo.

## About this repo
- It's a runnable Spring Boot application, so it has test Levels 1, 2 and 3.
- It's built with Maven (`pom.xml`); use `./mvnw`.
- Each supported database has its own Maven profile, Spring profile and compose file. The README sections that cover them are in the table below.
- Nothing depends on `springboot-multi-db`, so dependent tests (`rules/build-and-test.md`, section "Dependent tests") don't apply.
- It has no ishtech dependencies, so the test Level 3 precondition on upstream SNAPSHOTs doesn't apply.

## Read the doc before doing the thing
The docs are the source of truth. Don't guess commands: open the matching file and section first, and follow its links.

| Before you... | Read |
|---|---|
| work out what the application is and its tech stack | `README.md`, the introduction and section "Tech stack", subsection "Databases" |
| run test Level 1 (build with tests) | `README.md`, section "Build and Run", subsection "Junit Test": one command per database profile. The `h2` profile needs no database (section "DB", subsection "H2") |
| check the default JDK version or the other supported JDK versions | `README.md`, section "Tech stack"; which application version and Docker image tag belong to which JDK version, `JDK-VERSIONS.md`; for the `dev-jdkNN` branches and their releases, `rules/versions-and-releases.md`, section "JDK variants" |
| run test Level 2 (run the app with Maven) | `README.md`, section "Build and Run", subsection "Local Maven Run": one command per database profile. Set up the database for that profile first: section "DB", subsections "H2", "MariaDB / MySQL" and "PostgreSQL" |
| run test Level 3 (run with Docker compose) | `README.md`, section "Build and Run", subsections "Run with docker compose" (part "Individually": one compose file per database) and "All at once" (all compose files together) |
| run the API tests (part of Levels 2 and 3) | `README.md`, section "Build and Run", subsection "Test" |
| touch the database for any other reason | `README.md`, section "DB" |
| change the version or anything release-related, or check what CI enforces | `.github/workflows/cicd.yml` |
| report or fix a bug | `KNOWN-ISSUES.md` first, it may already be recorded |

If a doc is missing, wrong or unclear, fix the doc (see `rules/documentation.md`) instead of working around it.

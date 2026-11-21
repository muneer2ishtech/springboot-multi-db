# JDK versions

The default and other supported JDK versions are listed in the README, section "Tech stack".

- Releases for the default JDK version have plain version numbers, for example `x.y.z`. They are built from the branches `dev` and `main`.
- Releases for another supported JDK version have the same version number with the suffix `-jdkNN`, for example `x.y.z-jdk21` for JDK 21. They are built from the branch `dev-jdkNN`, for example `dev-jdk21`, from the same code, adapted where that JDK version needs it.
- Each release is published as the Docker image `muneer2ishtech/ishtech-springboot-multidb-app` on Docker Hub, with one tag for each database: the version followed by `-h2`, `-postgres`, `-mysql` or `-mariadb`, for example `x.y.z-postgres` or `x.y.z-jdk21-postgres`.
- Use the image tag that matches your JDK version.

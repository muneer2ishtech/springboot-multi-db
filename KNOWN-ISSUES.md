# Known Issues

Known issues that have been confirmed by testing but not yet fixed. Each entry has enough detail to reproduce and fix without re-investigating.

---

## 1. A GitHub release with a JDK-variant tag (`vx.y.z-jdkNN`) doesn't publish a Docker image

**Status:** Open. Recorded in full in springboot-books-app: [`KNOWN-ISSUES.md`, issue 1](https://github.com/muneer2ishtech/springboot-books-app/blob/dev/KNOWN-ISSUES.md).
**Impact:** Medium — a JDK-variant release publishes no Docker image, and nothing fails visibly.
**Affects:** `.github/workflows/cicd.yml`, trigger `on.push.tags: ['v[0-9]+.[0-9]+.[0-9]+']`, the same as in springboot-books-app.

The description, steps to reproduce, likely cause and suggested fix are in the linked entry; apply the same fix here, and verify it as described there, with this repo's image.

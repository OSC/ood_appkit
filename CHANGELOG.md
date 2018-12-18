# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Switch to Bootstrap 4

## [1.0.3] - 2017-07-17

### Changed

- Changed the `CHANGELOG.md` formatting.

### Fixed

- Loosened up version requirements on `ood_core` to better follow semantic
  versioning.

## 1.0.2 - 2017-06-12

### Fixed

- Fix word wrapping in `<pre><code></code></pre>` tags.
  [#45](https://github.com/OSC/ood_appkit/pull/45)

### Security

- Security fix: Cookies are kept within the Passenger app's base URI now.
  [#42](https://github.com/OSC/ood_appkit/pull/42)

[Unreleased]: https://github.com/OSC/ood_appkit/compare/v1.0.3...HEAD
[1.0.3]: https://github.com/OSC/ood_appkit/compare/v1.0.2...v1.0.3

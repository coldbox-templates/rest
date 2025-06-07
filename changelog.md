# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

* * *

## [Unreleased]

## [7.7.0] - 2025-06-07

## [7.6.0] - 2025-04-29

## [7.5.0] - 2025-03-19

### Improved

- Using Latest auto formatting with cfformat

## [7.4.0] - 2023-06-14

### Fixed

- gitignore files for modules so config folder can be added.

## [7.3.0] - 2023-06-14

### Added

- Vscode mappings for cbsecurity
- Tons of inline docs for module configurations so newbies can find what they need
- Leveraging the auth `User` of the `cbsecurity` module, so we can reuse what's already been built.

## [7.2.0] - 2023-05-19

### Fixed

- Added `allowPublicKeyRetrieval=true` to the `db` connection string
- Added missing bundle name and version in `.cfconfig.json` and `.env.example`

## [6.17.0] => 2023-MAR-20

- Added routing conventions to make it easier for the cli to add routes.

## [6.16.0] => 2023-MAR-20

### Added

- Changelog Tracking
- Github actions for auto building
- Latest ColdBox standards
- UI Updates
- Latest Alpine + Bootstrap Combo
- vscode introspection and helpers
- Docker build and compose consolidation to the `build` folder
- Cleanup of `tests` to new standards

[unreleased]: https://github.com/coldbox-templates/rest/compare/v7.7.0...HEAD
[7.7.0]: https://github.com/coldbox-templates/rest/compare/v7.6.0...v7.7.0
[7.6.0]: https://github.com/coldbox-templates/rest/compare/v7.5.0...v7.6.0
[7.5.0]: https://github.com/coldbox-templates/rest/compare/v7.4.0...v7.5.0
[7.4.0]: https://github.com/coldbox-templates/rest/compare/v7.3.0...v7.4.0
[7.3.0]: https://github.com/coldbox-templates/rest/compare/v7.2.0...v7.3.0
[7.2.0]: https://github.com/coldbox-templates/rest/compare/v7.0.0...v7.2.0

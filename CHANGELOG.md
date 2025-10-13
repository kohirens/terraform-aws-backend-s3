# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.0.1]

### Fixed

- Auto Version Relase
- Make label Optional

### Regular Maintenance

- Upgrade Auto Version Release

## [3.0.0]

### Changed

- Upgraded Terraform and AWS Provider

<a name="unreleased"></a>
## [Unreleased]


<a name="2.1.0"></a>
## [2.1.0] - 2023-11-30
### Added
- Prefix Variable


<a name="2.0.0"></a>
## [2.0.0] - 2023-11-30
### Continuous Integration
- Fixed Teardown Errors
- Upgraded Terraform Test
- Updated CircleCI Version Release Orb
- Added Status Badge

### Fixed
- Race Condition With State and Logging Buckets

### Removed
- Bucket ACLs


<a name="1.0.0"></a>
## [1.0.0] - 2022-12-24
### Added
- Moved Instructions
- Integration test

### Changed
- Renamed Resources
- Renamed Output Variables
- Upgrade to Terraform 1.0.0

### Continuous Integration
- Added Test Results To Artifacts
- Stored JUnit Test Results
- Updated Format And Parameters

### Fixed
- Terraform *.tf Line Indentations
- Setting Bucket Name In Main Module


<a name="0.0.2"></a>
## [0.0.2] - 2021-06-26
### Changed
- AWS Account to string to keep leading 0.
- Renamed resources


<a name="0.0.1"></a>
## 0.0.1 - 2021-05-15

[Unreleased]: https://github.com/kohirens/aws-tf-s3-backend.git/compare/2.1.0...HEAD
[2.1.0]: https://github.com/kohirens/aws-tf-s3-backend.git/compare/2.0.0...2.1.0
[2.0.0]: https://github.com/kohirens/aws-tf-s3-backend.git/compare/1.0.0...2.0.0
[1.0.0]: https://github.com/kohirens/aws-tf-s3-backend.git/compare/0.0.2...1.0.0
[0.0.2]: https://github.com/kohirens/aws-tf-s3-backend.git/compare/0.0.1...0.0.2

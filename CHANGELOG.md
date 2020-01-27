# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added

### Changed
- Tested RVM versions to `2.5`, `2.6`, and `2.7`.
- Source files to reflect changes requested by rubocop.

### Deprecated

### Removed
- `.rubocop.yml` in favor of just using defaults.

### Fixed

### Security

## [1.2.2] - 2018-03-07
### Added
- Rubocop to Travis-CI.

### Changed
- Versions of ruby tested against in Travis-CI.
- Single quotes to double quotes.
- `artisan optimize` to not run if Laravel version is greater than or equal to 5.5.

## [1.2.1] - 2017-02-24
### Fixed
- `:laravel_upload_dotenv_file_on_deploy` symbol in `laravel:upload_dotenv_file` task.

## [1.2.0] - 2017-02-22
### Added
- `:laravel_upload_dotenv_file_on_deploy` boolean config value to enable/disable dotenv file upload on deploy.

## [1.1.1] - 2017-01-29
### Changed
- Logic for checking whether or not ACL checks are perfomed to be in-line with the task instead of in the runlist.
- `laravel:ensure_acl_paths_exist` to run before `deploy:updating` instead of after `deploy:starting`.
- `deploy:set_permissions:acl` to run before `deploy:updated` instead of after `deploy:updating`.

## [1.1.0] - 2016-10-28
### Changed
- Linked directories to be more specific instead of simply just `storage` folder.
- Runlist to separate out tasks related to `:laravel_set_acl_paths`.

### Removed
- Config check against `:laravel_set_acl_paths` when merging values into `:file_permissions_paths` and `:file_permissions_users`.

### Fixed
- Creation of linked dirs to run under `shared_path` instead of under `release_path`.

## [1.0.1] - 2016-10-14
### Fixed
- `artisan storage:link` to not run if Laravel version is less than or equal to 5.3.

## [1.0.0] - 2016-10-12
### Added
- Editorconfig file.
- Rspec configuration.
- Travis-CI configuration.
- Additional README contents to better explain how the plugin works and should be developed.
- Inline comments to tasks file for every configuration value and task.
- `laravel:storage_link` task for creating public storage link.

### Changed
- Gitignore file to ignore more ruby-related files.
- MIT license to be up-to-date for 2016.
- Gemfile to use `Capistrano::Laravel::VERSION` instead of hardcoding it into the Gemfile.
- `laravel:configure_folders` to `laravel:resolve_linked_dirs` and `laravel:ensure_linked_dirs_exist`.
- `laravel:create_linked_acl_paths` to `laravel:resolve_acl_paths`.
- `laravel:optimize_config` to `laravel:config_cache`.
- `laravel:optimize_route` to `laravel:route_cache`.
- `laravel:optimize_release` to `laravel:optimize`.
- `laravel:migrate_db` to `laravel:migrate`.
- `laravel:rollback_db` to `laravel:migrate_rollback`.
- Runlist to reflect the refactored tasks.

### Removed
- The empty class `capistrano/laravel/helpers`.

### Fixed
- `laravel:artisan` task formatting so it can properly take inputs.

## [0.0.4] - 2016-10-02
### Changed
- `laravel:artisan` tasks to be ran more than once.

## [0.0.3] - 2016-03-07
### Added
- More documentation to the README.
- `Capistrano::Laravel::VERSION`.

### Changed
- Merged tasks files (artisan, laravel, migrations) into a single file.
- Task loading logic to read just a single file.

## [0.0.2] - 2013-11-12
### Changed
- Default `:file_permissions_user` to `:laravel_server_user` from `:webserver_user`.

## [0.0.1] - 2013-11-12
### Added
- Basic Laravel tasks: `laravel:artisan`, `laravel:artisan optimize`, `laravel:artisan migrate`.

[Unreleased]: https://github.com/capistrano/laravel/compare/v1.2.2...HEAD
[1.2.2]: https://github.com/capistrano/laravel/compare/v1.2.1...v1.2.2
[1.2.1]: https://github.com/capistrano/laravel/compare/v1.2.0...v1.2.1
[1.2.0]: https://github.com/capistrano/laravel/compare/v1.1.1...v1.2.0
[1.1.1]: https://github.com/capistrano/laravel/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/capistrano/laravel/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/capistrano/laravel/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/capistrano/laravel/compare/v0.0.4...v1.0.0
[0.0.4]: https://github.com/capistrano/laravel/compare/v0.0.3...v0.0.4
[0.0.3]: https://github.com/capistrano/laravel/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/capistrano/laravel/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/capistrano/laravel/releases/tag/v0.0.1

# ERPNext image for VCubi Platform

![ERPNext](https://img.shields.io/badge/ERPNext-13,_latest-blue)
![x86_64](https://img.shields.io/badge/x86_64-supported-brightgreen)
![aarch64](https://img.shields.io/badge/aarch64-supported-brightgreen)

## How to Use

### Pull image
    # from Docker Hub
    docker pull leadstec/erpnext:[tag]
    docker pull leadstec/php-aarch64:[tag]

### Build image
    docker-compose build erpnext

### LCS Schema & ENV

| ENV Variable              | Description               | Default | Accept Values | Required |
|---------------------------|---------------------------|---------|---------------|----------|
| FPM_WEB_MODE              | Run FPM in web mode       |  true   |  true,false   |          |
| FPM_PM_MAX_CHILDREN       |                           |    5    |               |          |
| FPM_PM_START_SERVERS      |                           |    2    |               |          |
| FPM_PM_MIN_SPARE_SERVERS  |                           |    1    |               |          |
| FPM_PM_MAX_SPARE_SERVERS  |                           |    3    |               |          |
| PHP_MEMORY_LIMIT          |                           |   128M  |               |          |
| PHP_MAX_EXECUTION_TIME    |                           |   30    |     |          |
| PHP_MAX_INPUT_TIME        |                           |   60    |     |          |
| PHP_SOCKET_TIMEOUT        |                           |   60    |     |          |
| PHP_OUTPUT_BUFFERING      |                           |   4096  |     |          |
| PHP_MAX_INPUT_VARS        |                           |   1000  |     |          |
| PHP_SHORT_OPEN_TAG        |                           |   On    | On,Off    |          |
| PHP_EXPOSE_PHP            |                           |   On    | On,Off    |          |
| PHP_TIMEZONE              |                           | Asia/Shanghai |     |          |
| PHP_ERROR_REPORTING       |                           | E_ALL & ~E_DEPRECATED & ~E_STRICT | | |
| PHP_DISPLAY_ERRORS        |                           |   Off   |  On,Off    |          |
| PHP_DISPLAY_STARTUP_ERRORS|                           |   Off   | On,Off    |          |
| PHP_LOG_ERRORS            |                           |   Off   | On,Off    |          |
| PHP_SESSION_GC_DIVISOR    |                           |  1000   |     |          |
| PHP_SESSION_GC_MAXLIFETIME|                           |  1440   |     |          |
| PHP_ENABLE_ADMINER        |                           |  false  | true,false    |          |


## Image Structure Test
    container-structure-test test --image leadstec/erpnext:tag --config tests/erpnext.yaml

## CHANGELOG


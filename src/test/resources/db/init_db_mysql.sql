-- DROP DATABASE IF EXISTS `multidb`;
CREATE DATABASE IF NOT EXISTS `multidb`
DEFAULT CHARACTER SET = utf8mb4
DEFAULT COLLATE = utf8mb4_unicode_ci
;

-- DROP USER IF EXISTS `multidbuser`@`%`;
CREATE USER IF NOT EXISTS `multidbuser`@`%`
IDENTIFIED BY 'multidbpass'
;

GRANT CREATE, REFERENCES, INDEX, ALTER, LOCK TABLES ON `multidb`.* TO `multidbuser`@`%`;
GRANT SELECT, INSERT, UPDATE ON `multidb`.* TO `multidbuser`@`%`;

FLUSH PRIVILEGES;

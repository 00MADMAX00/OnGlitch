-- ============================================================
-- OnGlitch: Add streaming/gaming social link columns to Wo_Users
-- Compatible with: MySQL 5.6, 5.7, 8.0, MariaDB, shared hosting
-- No information_schema access required.
--
-- HOW TO RUN:
--   phpMyAdmin → select your database → SQL tab → paste → Go
--
-- NOTE: If you see error #1060 "Duplicate column name" for any
--   column, that simply means it was already added previously.
--   Error #1060 is completely harmless — ignore it and continue.
--   All other errors should be investigated.
-- ============================================================

ALTER TABLE `Wo_Users` ADD COLUMN `twitch` VARCHAR(100) DEFAULT NULL;
ALTER TABLE `Wo_Users` ADD COLUMN `kick` VARCHAR(100) DEFAULT NULL;
ALTER TABLE `Wo_Users` ADD COLUMN `rumble` VARCHAR(100) DEFAULT NULL;
ALTER TABLE `Wo_Users` ADD COLUMN `tiktok` VARCHAR(100) DEFAULT NULL;
ALTER TABLE `Wo_Users` ADD COLUMN `discord` VARCHAR(150) DEFAULT NULL;
ALTER TABLE `Wo_Users` ADD COLUMN `steam` VARCHAR(100) DEFAULT NULL;
ALTER TABLE `Wo_Users` ADD COLUMN `facebook_gaming` VARCHAR(100) DEFAULT NULL;
ALTER TABLE `Wo_Users` ADD COLUMN `trovo` VARCHAR(100) DEFAULT NULL;
ALTER TABLE `Wo_Users` ADD COLUMN `dlive` VARCHAR(100) DEFAULT NULL;

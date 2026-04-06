-- ============================================================
-- OnGlitch: Add streaming/gaming social link columns
-- Target table: Wo_Users  (WoWonder uses the Wo_ prefix)
--
-- SAFE TO RUN MULTIPLE TIMES:
--   Each ALTER TABLE is wrapped in an IF-NOT-EXISTS check using
--   information_schema. If the column is already there, it is
--   skipped silently. Nothing is dropped, modified, or deleted.
--
-- HOW TO RUN:
--   phpMyAdmin → select database → SQL tab → paste → Go
--   OR via SSH:  mysql -u root -p your_db_name < onglitch_social_columns.sql
-- ============================================================

ALTER TABLE `Wo_Users`
  ADD COLUMN IF NOT EXISTS `twitch`          VARCHAR(100) DEFAULT NULL COMMENT 'Twitch username',
  ADD COLUMN IF NOT EXISTS `kick`            VARCHAR(100) DEFAULT NULL COMMENT 'Kick username',
  ADD COLUMN IF NOT EXISTS `rumble`          VARCHAR(100) DEFAULT NULL COMMENT 'Rumble username',
  ADD COLUMN IF NOT EXISTS `tiktok`          VARCHAR(100) DEFAULT NULL COMMENT 'TikTok username',
  ADD COLUMN IF NOT EXISTS `discord`         VARCHAR(150) DEFAULT NULL COMMENT 'Discord invite code or username',
  ADD COLUMN IF NOT EXISTS `steam`           VARCHAR(100) DEFAULT NULL COMMENT 'Steam community username',
  ADD COLUMN IF NOT EXISTS `facebook_gaming` VARCHAR(100) DEFAULT NULL COMMENT 'Facebook Gaming page username',
  ADD COLUMN IF NOT EXISTS `trovo`           VARCHAR(100) DEFAULT NULL COMMENT 'Trovo.live username',
  ADD COLUMN IF NOT EXISTS `dlive`           VARCHAR(100) DEFAULT NULL COMMENT 'DLive.tv username';

-- ============================================================
-- VERIFICATION — run this after to confirm all 9 columns exist.
-- You should see 9 rows returned.
-- ============================================================
SELECT
    COLUMN_NAME,
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    COLUMN_COMMENT
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME   = 'Wo_Users'
  AND COLUMN_NAME IN (
      'twitch', 'kick', 'rumble', 'tiktok', 'discord',
      'steam', 'facebook_gaming', 'trovo', 'dlive'
  )
ORDER BY COLUMN_NAME;

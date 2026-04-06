-- ============================================================
-- OnGlitch: Add streaming/gaming social link columns to WoWonder users table
--
-- SAFE TO RUN MULTIPLE TIMES:
--   Each block checks if the column already exists before adding it.
--   Will NOT drop, overwrite, or touch any existing data or columns.
--   All new columns default to NULL so existing users are unaffected.
--
-- HOW TO RUN:
--   Option A: phpMyAdmin → select your database → SQL tab → paste → Go
--   Option B: MySQL command line:
--             mysql -u root -p your_database_name < onglitch_social_columns.sql
--
-- WoWonder stores social links in the `users` table.
-- Existing columns (already present in WoWonder):
--   facebook, twitter, vk, linkedin, instagram, youtube, google
-- New columns added by this script:
--   twitch, kick, rumble, tiktok, discord, steam, facebook_gaming, trovo, dlive
-- ============================================================

-- Store current database name for use in checks
SET @dbname = DATABASE();
SET @tablename = 'users';

-- ---- twitch ----
SET @col = 'twitch';
SET @sql = IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA = @dbname
       AND TABLE_NAME   = @tablename
       AND COLUMN_NAME  = @col) = 0,
    CONCAT('ALTER TABLE `', @tablename, '` ADD COLUMN `twitch` VARCHAR(100) DEFAULT NULL COMMENT ''Twitch username'''),
    'SELECT ''twitch column already exists'' AS status'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ---- kick ----
SET @col = 'kick';
SET @sql = IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA = @dbname
       AND TABLE_NAME   = @tablename
       AND COLUMN_NAME  = @col) = 0,
    CONCAT('ALTER TABLE `', @tablename, '` ADD COLUMN `kick` VARCHAR(100) DEFAULT NULL COMMENT ''Kick username'''),
    'SELECT ''kick column already exists'' AS status'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ---- rumble ----
SET @col = 'rumble';
SET @sql = IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA = @dbname
       AND TABLE_NAME   = @tablename
       AND COLUMN_NAME  = @col) = 0,
    CONCAT('ALTER TABLE `', @tablename, '` ADD COLUMN `rumble` VARCHAR(100) DEFAULT NULL COMMENT ''Rumble username'''),
    'SELECT ''rumble column already exists'' AS status'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ---- tiktok ----
SET @col = 'tiktok';
SET @sql = IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA = @dbname
       AND TABLE_NAME   = @tablename
       AND COLUMN_NAME  = @col) = 0,
    CONCAT('ALTER TABLE `', @tablename, '` ADD COLUMN `tiktok` VARCHAR(100) DEFAULT NULL COMMENT ''TikTok username'''),
    'SELECT ''tiktok column already exists'' AS status'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ---- discord ----
-- Discord invite codes and usernames can be slightly longer
SET @col = 'discord';
SET @sql = IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA = @dbname
       AND TABLE_NAME   = @tablename
       AND COLUMN_NAME  = @col) = 0,
    CONCAT('ALTER TABLE `', @tablename, '` ADD COLUMN `discord` VARCHAR(150) DEFAULT NULL COMMENT ''Discord server invite code or username#tag'''),
    'SELECT ''discord column already exists'' AS status'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ---- steam ----
SET @col = 'steam';
SET @sql = IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA = @dbname
       AND TABLE_NAME   = @tablename
       AND COLUMN_NAME  = @col) = 0,
    CONCAT('ALTER TABLE `', @tablename, '` ADD COLUMN `steam` VARCHAR(100) DEFAULT NULL COMMENT ''Steam community username'''),
    'SELECT ''steam column already exists'' AS status'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ---- facebook_gaming ----
SET @col = 'facebook_gaming';
SET @sql = IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA = @dbname
       AND TABLE_NAME   = @tablename
       AND COLUMN_NAME  = @col) = 0,
    CONCAT('ALTER TABLE `', @tablename, '` ADD COLUMN `facebook_gaming` VARCHAR(100) DEFAULT NULL COMMENT ''Facebook Gaming page username'''),
    'SELECT ''facebook_gaming column already exists'' AS status'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ---- trovo ----
SET @col = 'trovo';
SET @sql = IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA = @dbname
       AND TABLE_NAME   = @tablename
       AND COLUMN_NAME  = @col) = 0,
    CONCAT('ALTER TABLE `', @tablename, '` ADD COLUMN `trovo` VARCHAR(100) DEFAULT NULL COMMENT ''Trovo.live username'''),
    'SELECT ''trovo column already exists'' AS status'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ---- dlive ----
SET @col = 'dlive';
SET @sql = IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA = @dbname
       AND TABLE_NAME   = @tablename
       AND COLUMN_NAME  = @col) = 0,
    CONCAT('ALTER TABLE `', @tablename, '` ADD COLUMN `dlive` VARCHAR(100) DEFAULT NULL COMMENT ''DLive.tv username'''),
    'SELECT ''dlive column already exists'' AS status'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ============================================================
-- VERIFICATION QUERY
-- Run this after the above to confirm all 9 columns were created:
-- ============================================================
SELECT
    COLUMN_NAME,
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    COLUMN_COMMENT
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME   = 'users'
  AND COLUMN_NAME IN (
      'twitch', 'kick', 'rumble', 'tiktok', 'discord',
      'steam', 'facebook_gaming', 'trovo', 'dlive'
  )
ORDER BY COLUMN_NAME;
-- Expected: 9 rows, one per column above.
-- If a column is missing from the result it was NOT added — check for errors.

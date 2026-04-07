-- ============================================================
-- OnGlitch: Hungarian (hu) and Georgian (ka) translations
-- for WoWonder's Wo_Langs table.
--
-- HOW IT WORKS:
--   WoWonder adds custom languages as new columns on Wo_Langs.
--   The column name matches the lang_key: 'Hungarian_hu' and 'Georgian_ka'.
--
-- STEP 1: Add the columns if they don't exist yet (safe to re-run).
-- STEP 2: Fill them with proper translations.
--
-- Run this in phpMyAdmin → select your database → SQL tab → Go
-- ============================================================

-- ── STEP 1: Ensure the columns exist ──────────────────────────────────
ALTER TABLE `Wo_Langs`
  ADD COLUMN IF NOT EXISTS `Hungarian_hu` LONGTEXT DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS `Georgian_ka`  LONGTEXT DEFAULT NULL;

-- ── STEP 2: Seed both columns with English as a safe fallback ─────────
-- This ensures no blank strings appear for untranslated keys.
UPDATE `Wo_Langs` SET `Hungarian_hu` = `english` WHERE `Hungarian_hu` IS NULL OR `Hungarian_hu` = '';
UPDATE `Wo_Langs` SET `Georgian_ka`  = `english` WHERE `Georgian_ka`  IS NULL OR `Georgian_ka`  = '';

-- ── STEP 3: Hungarian (Magyar) key translations ───────────────────────
-- Core authentication & navigation
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Bejelentkezés'          WHERE `lang_key` = 'login';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Jelszó'                 WHERE `lang_key` = 'password';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Új jelszó'              WHERE `lang_key` = 'new_password';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Email cím'              WHERE `lang_key` = 'email';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Regisztráció'           WHERE `lang_key` = 'register';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Kijelentkezés'          WHERE `lang_key` = 'logout';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Keresés'                WHERE `lang_key` = 'search';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Mentés'                 WHERE `lang_key` = 'save';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Törlés'                 WHERE `lang_key` = 'delete';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Mégse'                  WHERE `lang_key` = 'cancel';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Szerkesztés'            WHERE `lang_key` = 'edit';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Küldés'                 WHERE `lang_key` = 'send';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Hozzáadás'              WHERE `lang_key` = 'add';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Kész'                   WHERE `lang_key` = 'done';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Igen'                   WHERE `lang_key` = 'yes';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Nem'                    WHERE `lang_key` = 'no';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'OK'                     WHERE `lang_key` = 'ok';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Bezárás'                WHERE `lang_key` = 'close';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Tovább'                 WHERE `lang_key` = 'next';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Vissza'                 WHERE `lang_key` = 'back';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Feltöltés'              WHERE `lang_key` = 'upload';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Letöltés'               WHERE `lang_key` = 'download';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Megosztás'              WHERE `lang_key` = 'share';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Tetszik'                WHERE `lang_key` = 'like';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Nem tetszik'            WHERE `lang_key` = 'dislike';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Komment'                WHERE `lang_key` = 'comment';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Válasz'                 WHERE `lang_key` = 'reply';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Követ'                  WHERE `lang_key` = 'follow';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Követés visszavonása'   WHERE `lang_key` = 'unfollow';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Barát hozzáadása'       WHERE `lang_key` = 'add_friend';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Barát eltávolítása'     WHERE `lang_key` = 'unfriend';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Üzenet'                 WHERE `lang_key` = 'message';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Értesítések'            WHERE `lang_key` = 'notifications';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Beállítások'            WHERE `lang_key` = 'settings';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Profil'                 WHERE `lang_key` = 'profile';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Idővonat'               WHERE `lang_key` = 'timeline';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Hírfolyam'              WHERE `lang_key` = 'news_feed';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Csoportok'              WHERE `lang_key` = 'groups';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Oldalak'                WHERE `lang_key` = 'pages';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Események'              WHERE `lang_key` = 'events';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Videók'                 WHERE `lang_key` = 'videos';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Fotók'                  WHERE `lang_key` = 'photos';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Blogok'                 WHERE `lang_key` = 'blog';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Fórum'                  WHERE `lang_key` = 'forum';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Piactér'                WHERE `lang_key` = 'market';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Barátok'                WHERE `lang_key` = 'friends';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Követők'                WHERE `lang_key` = 'followers';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Követés'                WHERE `lang_key` = 'following';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Bejegyzések'            WHERE `lang_key` = 'posts';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Névjegy'                WHERE `lang_key` = 'about';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Tevékenységek'          WHERE `lang_key` = 'activities';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Ajándék küldése'        WHERE `lang_key` = 'send_a_gift';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Több betöltése'         WHERE `lang_key` = 'load_more_posts';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Felhasználónév'         WHERE `lang_key` = 'username';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Keresztnév'             WHERE `lang_key` = 'first_name';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Vezetéknév'             WHERE `lang_key` = 'last_name';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Születésnap'            WHERE `lang_key` = 'birthday';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Nem'                    WHERE `lang_key` = 'gender';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Férfi'                  WHERE `lang_key` = 'male';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Nő'                     WHERE `lang_key` = 'female';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Ország'                 WHERE `lang_key` = 'country';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Város'                  WHERE `lang_key` = 'city';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Cím'                    WHERE `lang_key` = 'address';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Munkahely'              WHERE `lang_key` = 'working';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Iskola'                 WHERE `lang_key` = 'school';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Weboldal'               WHERE `lang_key` = 'website';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Bio'                    WHERE `lang_key` = 'about_me';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Adatvédelem'            WHERE `lang_key` = 'privacy';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Biztonság'              WHERE `lang_key` = 'security';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Értesítési beállítások' WHERE `lang_key` = 'notification_settings';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Szociális linkek'       WHERE `lang_key` = 'social_links';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Elfelejtett jelszó'     WHERE `lang_key` = 'forgot_password';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Jelszó visszaállítása'  WHERE `lang_key` = 'reset_password';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Fiók megerősítése'      WHERE `lang_key` = 'confirm_account';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Üdvözöljük vissza!'     WHERE `lang_key` = 'welcome_back';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Bejegyzés létrehozása'  WHERE `lang_key` = 'create_post';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Mi jár a fejedben?'     WHERE `lang_key` = 'whats_on_your_mind';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Képek feltöltése'       WHERE `lang_key` = 'upload_photos';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Videó feltöltése'       WHERE `lang_key` = 'upload_video';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Szavazás létrehozása'   WHERE `lang_key` = 'create_poll';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Érzés/tevékenység'      WHERE `lang_key` = 'feeling_activity';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Élő közvetítés'         WHERE `lang_key` = 'go_live';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Bejegyzés megosztása'   WHERE `lang_key` = 'share_post';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Bejegyzés rögzítése'    WHERE `lang_key` = 'pin_post';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Bejegyzés szerkesztése' WHERE `lang_key` = 'edit_post';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Bejegyzés törlése'      WHERE `lang_key` = 'delete_post';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Jelentés'               WHERE `lang_key` = 'report';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Letiltás'               WHERE `lang_key` = 'block';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Meghívás'               WHERE `lang_key` = 'invite';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Csatlakozás'            WHERE `lang_key` = 'join';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Elhagyás'               WHERE `lang_key` = 'leave';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Tagok'                  WHERE `lang_key` = 'members';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Admin'                  WHERE `lang_key` = 'admin';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Moderátor'              WHERE `lang_key` = 'moderator';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Nyilvános'              WHERE `lang_key` = 'public';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Privát'                 WHERE `lang_key` = 'private';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Barátok'                WHERE `lang_key` = 'friends_btn';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Találj barátokat'       WHERE `lang_key` = 'find_friends';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Baráti kérelem'         WHERE `lang_key` = 'friend_request';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Elfogadás'              WHERE `lang_key` = 'accept';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Elutasítás'             WHERE `lang_key` = 'decline';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Profilkép'              WHERE `lang_key` = 'profile_picture';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Borítókép'              WHERE `lang_key` = 'cover_photo';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Albumok'                WHERE `lang_key` = 'albums';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Ajándékok'              WHERE `lang_key` = 'gifts';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Pontok'                 WHERE `lang_key` = 'points';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Élő'                    WHERE `lang_key` = 'live';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Reels'                  WHERE `lang_key` = 'reels';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Filmek'                 WHERE `lang_key` = 'movies';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Állások'                WHERE `lang_key` = 'jobs';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Ajánlatok'              WHERE `lang_key` = 'offers';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Finanszírozás'          WHERE `lang_key` = 'funding';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Termékek'               WHERE `lang_key` = 'products';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Kosár'                  WHERE `lang_key` = 'cart';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Fizetés'                WHERE `lang_key` = 'checkout';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Mentett bejegyzések'    WHERE `lang_key` = 'saved_posts';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Emlékek'                WHERE `lang_key` = 'memories';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Keresés emberek, oldalak, csoportok és hashtagek között' WHERE `lang_key` = 'search_placeholder';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Profil befejezése'      WHERE `lang_key` = 'pr_completion';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Profilkép hozzáadása'   WHERE `lang_key` = 'ad_pr_picture';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Neved hozzáadása'       WHERE `lang_key` = 'add_ur_name';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Munkahelyed hozzáadása' WHERE `lang_key` = 'ad_ur_workplace';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Országod hozzáadása'    WHERE `lang_key` = 'ad_ur_country';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Címed hozzáadása'       WHERE `lang_key` = 'ad_ur_address';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Beállítások mentve!'    WHERE `lang_key` = 'settings_updated';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Hiba történt'           WHERE `lang_key` = 'error_occurred';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Nincs találat'          WHERE `lang_key` = 'no_result';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Bejegyzés közzétéve!'   WHERE `lang_key` = 'post_published';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Üdvözöljük!'            WHERE `lang_key` = 'welcome';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Csatlakozzon most'      WHERE `lang_key` = 'join_now';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Ingyenes regisztráció'  WHERE `lang_key` = 'register_free';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Már van fiókja?'        WHERE `lang_key` = 'already_have_account';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Nincs még fiókja?'      WHERE `lang_key` = 'dont_have_account';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Felhasználó nem található' WHERE `lang_key` = 'user_not_found';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Helytelen jelszó'       WHERE `lang_key` = 'wrong_password';
UPDATE `Wo_Langs` SET `Hungarian_hu` = 'Email már foglalt'       WHERE `lang_key` = 'email_taken';

-- ── STEP 4: Georgian (ქართული) key translations ───────────────────────
UPDATE `Wo_Langs` SET `Georgian_ka` = 'შესვლა'                  WHERE `lang_key` = 'login';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'პაროლი'                  WHERE `lang_key` = 'password';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ახალი პაროლი'            WHERE `lang_key` = 'new_password';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ელ-ფოსტა'               WHERE `lang_key` = 'email';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'რეგისტრაცია'             WHERE `lang_key` = 'register';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'გასვლა'                  WHERE `lang_key` = 'logout';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ძებნა'                   WHERE `lang_key` = 'search';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'შენახვა'                 WHERE `lang_key` = 'save';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'წაშლა'                   WHERE `lang_key` = 'delete';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'გაუქმება'                WHERE `lang_key` = 'cancel';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'რედაქტირება'             WHERE `lang_key` = 'edit';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'გაგზავნა'                WHERE `lang_key` = 'send';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'დამატება'                WHERE `lang_key` = 'add';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'მზადაა'                  WHERE `lang_key` = 'done';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'დიახ'                    WHERE `lang_key` = 'yes';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'არა'                     WHERE `lang_key` = 'no';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'კარგი'                   WHERE `lang_key` = 'ok';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'დახურვა'                 WHERE `lang_key` = 'close';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'შემდეგი'                 WHERE `lang_key` = 'next';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'უკან'                    WHERE `lang_key` = 'back';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ატვირთვა'               WHERE `lang_key` = 'upload';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'გადმოწერა'              WHERE `lang_key` = 'download';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'გაზიარება'              WHERE `lang_key` = 'share';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'მოწონება'               WHERE `lang_key` = 'like';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'კომენტარი'              WHERE `lang_key` = 'comment';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'პასუხი'                 WHERE `lang_key` = 'reply';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'გამოწერა'               WHERE `lang_key` = 'follow';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'გამოწერის გაუქმება'     WHERE `lang_key` = 'unfollow';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'მეგობრის დამატება'      WHERE `lang_key` = 'add_friend';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'მეგობრობის გაუქმება'    WHERE `lang_key` = 'unfriend';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'შეტყობინება'            WHERE `lang_key` = 'message';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'შეტყობინებები'          WHERE `lang_key` = 'notifications';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'პარამეტრები'            WHERE `lang_key` = 'settings';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'პროფილი'                WHERE `lang_key` = 'profile';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ქრონიკა'                WHERE `lang_key` = 'timeline';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'სიახლეები'              WHERE `lang_key` = 'news_feed';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ჯგუფები'                WHERE `lang_key` = 'groups';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'გვერდები'               WHERE `lang_key` = 'pages';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ღონისძიებები'           WHERE `lang_key` = 'events';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ვიდეოები'               WHERE `lang_key` = 'videos';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ფოტოები'                WHERE `lang_key` = 'photos';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ბლოგი'                  WHERE `lang_key` = 'blog';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ფორუმი'                 WHERE `lang_key` = 'forum';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ბაზარი'                 WHERE `lang_key` = 'market';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'მეგობრები'              WHERE `lang_key` = 'friends';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'გამომწერები'            WHERE `lang_key` = 'followers';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'გამოწერილი'             WHERE `lang_key` = 'following';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'პოსტები'                WHERE `lang_key` = 'posts';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ჩემ შესახებ'            WHERE `lang_key` = 'about';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'აქტივობები'             WHERE `lang_key` = 'activities';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'საჩუქრის გაგზავნა'      WHERE `lang_key` = 'send_a_gift';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'მეტის ჩვენება'          WHERE `lang_key` = 'load_more_posts';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'მომხმარებელი'           WHERE `lang_key` = 'username';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'სახელი'                 WHERE `lang_key` = 'first_name';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'გვარი'                  WHERE `lang_key` = 'last_name';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'დაბადების თარიღი'       WHERE `lang_key` = 'birthday';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'სქესი'                  WHERE `lang_key` = 'gender';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'მამრობითი'              WHERE `lang_key` = 'male';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'მდედრობითი'             WHERE `lang_key` = 'female';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ქვეყანა'                WHERE `lang_key` = 'country';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ქალაქი'                 WHERE `lang_key` = 'city';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'მისამართი'              WHERE `lang_key` = 'address';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'სამუშაო ადგილი'        WHERE `lang_key` = 'working';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'სკოლა'                  WHERE `lang_key` = 'school';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ვებსაიტი'               WHERE `lang_key` = 'website';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ბიო'                    WHERE `lang_key` = 'about_me';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'კონფიდენციალურობა'      WHERE `lang_key` = 'privacy';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'უსაფრთხოება'            WHERE `lang_key` = 'security';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'სოციალური ბმულები'      WHERE `lang_key` = 'social_links';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'პაროლის დავიწყება'      WHERE `lang_key` = 'forgot_password';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'პაროლის აღდგენა'        WHERE `lang_key` = 'reset_password';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'კეთილი დაბრუნება!'      WHERE `lang_key` = 'welcome_back';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'პოსტის შექმნა'          WHERE `lang_key` = 'create_post';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'რა გაქვთ მხედველობაში?' WHERE `lang_key` = 'whats_on_your_mind';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ფოტოების ატვირთვა'      WHERE `lang_key` = 'upload_photos';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ვიდეოს ატვირთვა'        WHERE `lang_key` = 'upload_video';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'გამოკითხვის შექმნა'     WHERE `lang_key` = 'create_poll';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ლაივი'                  WHERE `lang_key` = 'go_live';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'პოსტის გაზიარება'       WHERE `lang_key` = 'share_post';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'პოსტის რედაქტირება'     WHERE `lang_key` = 'edit_post';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'პოსტის წაშლა'           WHERE `lang_key` = 'delete_post';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'საჩივარი'               WHERE `lang_key` = 'report';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'დაბლოკვა'               WHERE `lang_key` = 'block';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'მოწვევა'                WHERE `lang_key` = 'invite';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'შეერთება'               WHERE `lang_key` = 'join';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'გასვლა'                 WHERE `lang_key` = 'leave';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'წევრები'                WHERE `lang_key` = 'members';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ადმინი'                 WHERE `lang_key` = 'admin';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'საჯარო'                 WHERE `lang_key` = 'public';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'პირადი'                 WHERE `lang_key` = 'private';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'მეგობრების პოვნა'       WHERE `lang_key` = 'find_friends';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'მეგობრობის მოთხოვნა'    WHERE `lang_key` = 'friend_request';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'მიღება'                 WHERE `lang_key` = 'accept';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'უარყოფა'                WHERE `lang_key` = 'decline';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'პროფილის სურათი'        WHERE `lang_key` = 'profile_picture';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'გარეკანის ფოტო'         WHERE `lang_key` = 'cover_photo';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ალბომები'               WHERE `lang_key` = 'albums';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ლაივი'                  WHERE `lang_key` = 'live';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'მოკლე ვიდეოები'         WHERE `lang_key` = 'reels';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'პროდუქტები'             WHERE `lang_key` = 'products';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'შენახული პოსტები'       WHERE `lang_key` = 'saved_posts';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'მოგონებები'             WHERE `lang_key` = 'memories';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ადამიანების, გვერდების, ჯგუფების და ჰეშტეგების ძებნა' WHERE `lang_key` = 'search_placeholder';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'პროფილის შევსება'       WHERE `lang_key` = 'pr_completion';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'პროფილის სურათის დამატება' WHERE `lang_key` = 'ad_pr_picture';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'სახელის დამატება'       WHERE `lang_key` = 'add_ur_name';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'სამუშაო ადგილის დამატება' WHERE `lang_key` = 'ad_ur_workplace';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ქვეყნის დამატება'       WHERE `lang_key` = 'ad_ur_country';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'მისამართის დამატება'    WHERE `lang_key` = 'ad_ur_address';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'პარამეტრები განახლდა!'   WHERE `lang_key` = 'settings_updated';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'შეცდომა მოხდა'          WHERE `lang_key` = 'error_occurred';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'შედეგი არ მოიძებნა'     WHERE `lang_key` = 'no_result';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'მოგესალმებით!'          WHERE `lang_key` = 'welcome';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ახლავე შეუერთდი'        WHERE `lang_key` = 'join_now';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'უკვე გაქვთ ანგარიში?'   WHERE `lang_key` = 'already_have_account';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'ჯერ არ გაქვთ ანგარიში?' WHERE `lang_key` = 'dont_have_account';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'მომხმარებელი ვერ მოიძებნა' WHERE `lang_key` = 'user_not_found';
UPDATE `Wo_Langs` SET `Georgian_ka` = 'პაროლი არასწორია'        WHERE `lang_key` = 'wrong_password';

-- ── VERIFICATION ──────────────────────────────────────────────────────
-- Run this to confirm translations were saved:
-- SELECT lang_key, english, Hungarian_hu, Georgian_ka
-- FROM Wo_Langs
-- WHERE lang_key IN ('login','password','save','notifications','timeline')
-- LIMIT 10;

# OnGlitch — Design Implementation Guide

## What We Are Building

**OnGlitch** is a gaming-focused social network built on **WoWonder** (a PHP social network platform) with the **Vikinger** design system implemented on top of it.

The goal is: **Vikinger's visual design + WoWonder's backend functionality**.

Every new feature or fix must respect this duality:
- **Vikinger elements** (hexagon avatars, section navigation, stat bars, social link icons) → use **Vikinger CSS classes and `xm_hexagon.min.js`**
- **WoWonder elements** (post feeds, notifications, messages, settings, modals) → use **WoWonder CSS/JS only**

**Never mix them.** Applying WoWonder CSS to Vikinger hexagon elements (or vice versa) will break the design.

---

## Repository Structure

```
/workspace/                         ← WoWonder theme root
├── HTML/                           ← Vikinger HTML reference designs (READ ONLY — do not modify)
│   ├── profile-timeline.html       ← Reference: what the timeline page should look like
│   ├── js/
│   │   ├── vendor/
│   │   │   └── xm_hexagon.min.js   ← Vikinger hexagon canvas library
│   │   └── global/
│   │       └── global.hexagons.js  ← Reference hexagon init params (sizes, colours)
│   └── css/
│       └── raw/styles.css          ← Vikinger CSS (reference only)
├── timeline/
│   ├── content.phtml               ← ★ MAIN FILE: Profile/timeline page (Vikinger design implemented here)
│   ├── profile-completion.phtml    ← Profile completion bar with hide checkbox
│   └── following-followers-sidebar.phtml
├── sidebar/
│   └── profile-sidebar-user-list.phtml  ← Sidebar following/followers avatar (Vikinger hexagon)
├── story/
│   └── publisher-box.phtml         ← Create Post box (Vikinger hexagon avatar)
├── setting/
│   └── social-links.phtml          ← User social links settings panel (includes streaming platforms)
├── container.phtml                 ← Global wrapper: loads xm_hexagon.min.js, Wo_InitVikHexagons()
├── style.phtml                     ← Global theme CSS overrides (OnGlitch-specific fixes)
├── header/
│   └── content.phtml               ← Site header/navbar (WoWonder — do not add Vikinger nav here)
├── onglitch_social_columns.sql     ← SQL migration: adds streaming platform columns to Wo_Users
└── ONGLITCH_README.md              ← This file
```

---

## The Core Rule: Two Separate Systems

### Vikinger System
- **CSS**: Inline `<style>` block at the top of `timeline/content.phtml`
- **JS**: `xm_hexagon.min.js` loaded globally in `container.phtml`
- **Hexagon sizes** (from `HTML/js/global/global.hexagons.js`):
  - Big profile avatar: `hexagon-148-164`, progress `hexagon-progress-124-136`, border `hexagon-border-124-136`, image `hexagon-image-100-110`
  - Small avatars (sidebar, posts): `hexagon-image-30-32`, `hexagon-progress-40-44`, `hexagon-border-40-44`
  - Gender badge: `hexagon-40-44` (filled solid)
- **XM_Hexagon API**: `new XM_Hexagon({container: '.css-selector', ...})` or `new XM_Hexagon({containerElement: domEl, ...})`

### WoWonder System
- **CSS**: `style.phtml` (global overrides), WoWonder theme CSS files
- **JS**: jQuery, WoWonder's `requests.php` AJAX, `container.phtml` click handlers
- **AJAX navigation**: `data-ajax="?link1=..."` attributes on links, handled by `container.phtml` line ~309
- **Table prefix**: All WoWonder database tables use `Wo_` prefix (e.g. `Wo_Users`, `Wo_Posts`)

---

## Key File: `timeline/content.phtml`

This is the most important file. It contains the entire Vikinger profile header implemented into WoWonder.

### Structure (top to bottom):

```
1. PHP: $IsOwner, $IsOwnerUser, profile completion check
2. <style> block: All Vikinger CSS for the profile header (inline so it loads with AJAX)
3. window._woProfileGenderColors: PHP → JS gender colour variable
4. <div class="row page-margin profile wo_user_profile">
   └── <div class="profile-container">
       └── <div class="card hovercard">
           ├── <div class="cardheader user-cover">    ← Cover image + upload form
           ├── <div class="problackback">              ← Hidden (CSS display:none)
           └── <div class="pic-info-cont">            ← Main info bar (148px tall)
               ├── user-avatar.flip.big               ← Vikinger hexagon avatar (absolute pos, top:-82px)
               │   ├── hexagon-148-164                ← White outer ring fill
               │   ├── hexagon-image-100-110          ← Clipped avatar image
               │   ├── hexagon-progress-124-136       ← Coloured gradient ring (gender colour)
               │   ├── hexagon-border-124-136         ← Grey border ring
               │   └── user-avatar-badge              ← Gender icon badge (bottom-right)
               │       └── hexagon-40-44              ← Solid filled badge hexagon
               ├── div.info                           ← Name, @username, website URL (absolute center)
               ├── div.user-stats                     ← Posts/Following/Followers/Flag (absolute left)
               ├── div.profile-header-social-links-wrap ← Social icons (absolute right)
               └── div.options-buttons                ← Edit/Activities/Follow buttons (absolute top-right)
5. Vikinger profile hexagon init <script>
6. Section navigation <nav class="section-navigation">
7. PHP: Profile completion bar
8. col-md-8: Timeline content (posts, photos, videos, etc.)
9. col-md-4: Sidebar (right_user_info HIDDEN, albums, following, followers, etc.)
10. Modals + JavaScript functions
```

### Gender System

```php
$__gender_raw = strtolower(trim($wo['user_profile']['gender'] ?? ''));
// male   → ring: ['#41efff','#615dfa'] (blue/cyan)   badge: onglitch.com/male.png
// female → ring: ['#ff6ec7','#f8468d'] (pink)         badge: onglitch.com/female.png
// other  → ring: ['#c084fc','#7c3aed'] (purple)       badge: onglitch.com/none.png
```

`window._woProfileGenderColors` is set from PHP and read by `Wo_InitVikHexagons()` in `container.phtml` so ALL hexagon rings on the timeline page use the profile owner's gender colour.

---

## Key File: `container.phtml`

Global wrapper loaded on every page. Critical additions:

```html
<!-- Line ~288: Vikinger XM_Hexagon loaded globally -->
<script src="{theme_url}/HTML/js/vendor/xm_hexagon.min.js"></script>
<script>
function Wo_InitVikHexagons() { ... }  // Initialises all hexagon-image-30-32, hexagon-progress-40-44 etc.
$(document).ready(function() { Wo_InitVikHexagons(); ... });
$(document).on('wo_ajax_page_loaded', function() { setTimeout(Wo_InitVikHexagons, 300); });
</script>
```

And after AJAX navigation (line ~466):
```js
box.html(data);
$(document).trigger('wo_ajax_page_loaded');  // ← Re-fires hexagon init
```

**Critical**: `XM_Hexagon` uses:
- `container: '.css-selector'` → when passing a CSS selector string
- `containerElement: domElement` → when passing a DOM element directly

Using `container: domElement` will fail silently (renders blank).

---

## Key File: `sidebar/profile-sidebar-user-list.phtml`

Renders each follower/following avatar in the sidebar. Must use Vikinger hexagon structure:

```html
<div class="sidebar_user_data">
  <a href="{url}" data-ajax="?link1=timeline&u={username}">
    <div class="user-avatar small no-outline">
      <div class="user-avatar-content">
        <div class="hexagon-image-30-32" data-src="{avatar_url}"></div>
      </div>
      <div class="user-avatar-progress">
        <div class="hexagon-progress-40-44"></div>
      </div>
      <div class="user-avatar-progress-border">
        <div class="hexagon-border-40-44"></div>
      </div>
    </div>
  </a>
</div>
```

`Wo_InitVikHexagons()` in `container.phtml` initialises these automatically via `containerElement`.

---

## Key File: `story/publisher-box.phtml`

Create Post box. Avatar must use Vikinger hexagon:

```html
<div class="user-avatar small no-outline">
  <div class="user-avatar-content">
    <div class="hexagon-image-30-32" data-src="{user_avatar}"></div>
  </div>
  <div class="user-avatar-progress">
    <div class="hexagon-progress-40-44"></div>
  </div>
  <div class="user-avatar-progress-border">
    <div class="hexagon-border-40-44"></div>
  </div>
</div>
```

---

## Key File: `setting/social-links.phtml`

User settings panel for social/streaming links. Includes all platforms:

**Standard social**: Facebook, Twitter/X, VK, LinkedIn, Instagram, YouTube  
**Streaming/Gaming** (added for OnGlitch): Twitch, Kick, Rumble, TikTok, Discord, Steam, Facebook Gaming, Trovo, DLive

These streaming fields require database columns. Run `onglitch_social_columns.sql` once:
```sql
ALTER TABLE `Wo_Users` ADD COLUMN `twitch` VARCHAR(100) DEFAULT NULL;
-- (and 8 more columns — see the SQL file)
```

Social icons are displayed in `timeline/content.phtml` inside the `profile-header-social-links-wrap` div using inline SVG icons with brand colours.

---

## Navigation System

WoWonder uses AJAX navigation via `data-ajax` attributes:
```html
<a href="/page" data-ajax="?link1=timeline&u=username">Link</a>
```

The click handler in `container.phtml` intercepts these, loads content via `ajax_loading.php`, and replaces `#contnet` with `box.html(data)`. After this, `$(document).trigger('wo_ajax_page_loaded')` fires to re-init hexagons.

**Section Navigation** (Vikinger tabs — Timeline, Groups, Photos, etc.):
- Uses `<a class="section-menu-item">` elements inside `<nav class="section-navigation">`
- Must use `<span class="section-menu-item-text">` NOT `<p>` inside the `<a>` (invalid HTML breaks clicks)
- Has CSS animation: icon slides up, text fades in on hover/active

---

## Profile Completion Bar

`timeline/profile-completion.phtml` — shown to profile owner when completion < 100%.  
Has a "Hide" checkbox that uses `localStorage` keyed by user ID to remember dismissal.

---

## Style Conventions

### `style.phtml` (global overrides)
Only WoWonder-specific overrides that don't conflict with Vikinger. Currently contains:
- Vikinger small avatar dimensions (`.user-avatar.small`)
- Rounded corners on `.card.hovercard` and `.section-navigation`
- `.right_user_info { display: none }` — hides duplicate stats sidebar
- `pointer-events` fix for section-menu-item clicks

### `timeline/content.phtml` inline `<style>` block
All Vikinger profile header CSS. This is inline (not a separate file) so it loads correctly with WoWonder's AJAX content injection.

---

## Database

**WoWonder table prefix**: `Wo_` (e.g. `Wo_Users`, `Wo_Posts`, `Wo_Groups`)

**Social links** are stored as columns on `Wo_Users`:
- Existing: `facebook`, `twitter`, `vk`, `linkedin`, `instagram`, `youtube`, `google`
- Added by OnGlitch: `twitch`, `kick`, `rumble`, `tiktok`, `discord`, `steam`, `facebook_gaming`, `trovo`, `dlive`

The `update_socialinks_setting` WoWonder endpoint saves the social links form. The new streaming fields must be mapped in WoWonder's backend API handler to be saved.

---

## Common Mistakes to Avoid

| ❌ Wrong | ✓ Correct |
|---------|-----------|
| Adding Vikinger's `sidebar.js` or `app.js` to WoWonder | Only `xm_hexagon.min.js` from Vikinger |
| Using `container: domElement` in XM_Hexagon | Use `containerElement: domElement` |
| Adding `<p>` inside `<a class="section-menu-item">` | Use `<span class="section-menu-item-text">` |
| Adding `#navigation-widget-mobile` to `container.phtml` | WoWonder has its own mobile nav (`.side_slide_menu`) |
| Modifying `container.phtml` or `header/content.phtml` for Vikinger layout | Only add global JS/CSS helpers, never layout changes |
| Touching WoWonder's PHP functions/API | Only modify `.phtml` template files in the theme folder |
| Using WoWonder CSS on Vikinger hexagon elements | Hexagons only understand Vikinger CSS |

---

## Working Branch

All work is on branch: `cursor/timeline-page-redesign-a431`  
Base branch: `main`  
GitHub: `https://github.com/00MADMAX00/OnGlitch`

---

## Quick Reference: Hexagon Sizes

| Usage | Image div | Progress ring | Border ring |
|-------|-----------|---------------|-------------|
| Main profile avatar | `hexagon-image-100-110` (100×110) | `hexagon-progress-124-136` (8px line) | `hexagon-border-124-136` |
| Outer border fill | `hexagon-148-164` (fill:true) | — | — |
| Gender badge | `hexagon-40-44` (fill:true, solid) | — | — |
| Sidebar / posts / comments | `hexagon-image-30-32` (30×32) | `hexagon-progress-40-44` (3px line) | `hexagon-border-40-44` |

All hexagons: `roundedCorners: true`. Small ones: `roundedCornerRadius: 1`.

# Sidebar Expand on Hover
![](./screenshot.png)

Zen mod to auto expand the sidebar on hover.

- **IMPORTANT**: Turn the mod off or on with the fullscreen toggle (F11)
- **IMPORTANT**: Use the mod in single toolbar or multiple toolbars mode, never on collapsed toolbar mode

## Install (this fork)

Zen does **not** load a mod from `preferences.json` alone. You always need **`chrome.css`** and **`preferences.json`** together, with matching `mod.autoexpand.*` names.

### Option A — Local install (recommended for testing)

From this repo folder:

```powershell
pwsh -File scripts/install-local.ps1
```

Pick your Zen profile when prompted, then restart Zen or disable/enable the mod under **Settings → Zen Mods**.

The script pins **`file://`** URLs in `zen-themes.json` so **Check for updates** does not replace your files with the official theme-store build (which does not include fork-only settings).

```powershell
pwsh -File scripts/install-local.ps1 -AllProfiles
```

### Option B — Import from GitHub

1. Push this repo to GitHub (`main` branch).
2. In Zen: **Settings → Zen Mods → Import**.
3. Select **`mod-import.json`** from this repo.

Import downloads `chrome.css` and `preferences.json` from the raw GitHub URLs in that file. If import fails, use Option A.

### Option C — Official marketplace mod

Install [Sidebar Expand on Hover](https://zen-browser.app/mods/bd92a9a0-1c00-4187-a66e-94c389fa5a59/) from Zen Mods, then run **Check for updates**, or use Option A to overwrite with this fork.

## Customization options

In the mods menu, click the gear icon:

- Performance mode, collapsed/expanded widths, animation delays
- Essentials layout, fade sleeping tabs/folders
- Hide workspace indicator
- **Space above pinned tabs when workspace indicator is hidden (px)** — e.g. `32px`
- Remove pinned-tabs separator line

# Changelog

All notable changes to Differentialis are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/) and the project uses
[Semantic Versioning](https://semver.org/).

When cutting a release, add a section here and use it as the release notes:
`gh release create vX.Y.Z --notes "$(scripts/changelog.sh X.Y.Z)"`.


## [Unreleased]

### Added
- **In-app updates** — Differentialis now downloads, verifies, installs, and relaunches updates
  itself instead of opening the DMG download page in a browser. The update banner's button
  ("Update") and **Check for Updates…** both install in place; updates are verified with an
  EdDSA-signed appcast attached to the latest GitHub release.
- **`differentialis` command-line launcher.** A thin shell script is bundled inside the app at
  `Contents/Resources/differentialis`; install it from **Differentialis ▸ Install Command Line
  Tool…** (one password prompt, then it's on your `$PATH`). Run `differentialis <repo>`,
  `differentialis <a> <b>`, or `differentialis <base> <mine> <theirs>` to open a diff from any
  directory. It talks to Differentialis by bundle id and works whether the app is already running
  or not — the app now handles the `open` Apple Event (not just launch arguments) and registers as
  a Viewer for folders and files so LaunchServices routes the paths instead of bouncing them. A
  single non-repository path now shows an in-app error instead of doing nothing.

### Changed
- Added **Sparkle** as the app's only third-party dependency, used solely for the self-updater.
  The diff, merge, and git engines remain dependency-free. Releases now carry a monotonic
  `CFBundleVersion` and an `appcast.xml` so installed apps can find and verify new versions.
- **Text layout (Split / Unified) and image comparison mode now persist across files and
  launches.** Switching to Unified for one file diff used to reset to Split when you opened
  another file. The layout choice is now a global default stored in UserDefaults — your last
  choice carries over to the next comparison and survives app relaunch. The same applies to
  image diff modes (⌘1–⌘4).

### Improved
- **Collapsible sidebar panels now show their title when collapsed.** The commit-history,
  changed-files, and changeset-file-list panels display a vertical title (e.g. "HISTORY", "FILES")
  in the collapsed rail so you can tell at a glance what each rail expands to. The expanded
  headers now show the same title horizontally.

## [0.1.6] — 2026-06-24

### Added
- **Right-click a changed file to copy its name or path.** The context menu in the repository /
  changeset file list and the folder-comparison list offers **Copy Name**, **Copy Path**
  (repo-relative), and **Copy Full Path**.

### Fixed
- **Image comparisons no longer get stuck loading for added or deleted files.** When one side of an
  image comparison doesn't exist (a newly added or a deleted file), the view spun on a loading
  indicator forever because it waited for both sides to decode. It now renders whichever side is
  present and shows a clear placeholder explaining the other side is absent.

## [0.1.5] — 2026-06-23

### Fixed
- **Fixed a crash when viewing a diff or running a custom comparison** (e.g. a commit hash against
  a branch). Building a file comparison resolved the repository root by shelling out to git from
  inside a SwiftUI view body; on the main thread that re-entered the render loop and aborted. The
  repository root is now resolved once, off the main thread, so diffs render without crashing.
- **The Commits ⇄ Files toggle is fully clickable again.** Only the small icon was hit-testable, so
  switching modes often did nothing; the whole control (and the panel collapse buttons) now respond.

## [0.1.4] — 2026-06-23

### Fixed
- **Repository view no longer crashes or freezes.** Git commands — and large text diffs and image
  decoding — now run off the main thread instead of blocking it. Previously, opening a repository or
  loading a big diff could hang the UI or crash with a segmentation fault.
- **Sidebar no longer clips its contents.** The project sidebar is now a fixed-width column that the
  repository view's panes can't squeeze, so the logo and labels never get cut off the window's left edge.
- **Repository layout fixes** — the changed-files panel collapses again to give the diff more room, and
  the working-copy / "no working changes" states fill their panes instead of floating to the center.

## [0.1.3] — 2026-06-23

### Added
- **File Properties** comparison viewer — a popover (the ⓘ button in a text or image
  comparison) comparing A/B file metadata: size, type, dates, permissions, and for images the
  dimensions, format, and color space, with differing values highlighted.
- **Collapsible panels** in the repository view — hide the commit / files list or the
  changed-files list (matching collapse controls in each panel header) to give the diff more room.
- **Changelog** link in the Help menu.
- One-Up image mode: a clear **A | B** selector plus keyboard control — Space toggles, ← / →
  pick a side, ⇧⌘S swaps.

### Changed
- Bundle identifier migrated to `app.differentialis.*` to match the differentialis.app domain.

### Fixed
- The update banner summarizes the first real line of the release notes instead of showing a
  raw `## What's new` heading.

## [0.1.2] — 2026-06-23

### Added
- **Projects sidebar** — opened repositories persist in the sidebar, one click away.
- **Commits ⇄ Files** — flip the repository view between commit history and a grouped,
  filterable list of working-copy changes (HEAD vs working tree).
- **Paste a commit hash** in the Custom Comparison popover, or pick from history.
- **Keyboard shortcuts + Help menu** — full menu-bar commands and a Keyboard Shortcuts cheat
  sheet (`⌘/`); bare `[` / `]` also navigate changes.
- **Automatic updates** — checks GitHub Releases on launch and offers the notarized download,
  plus a **Check for Updates…** app-menu command.

### Fixed
- Window could be resized below its content minimum, squishing the layout.
- Sidebar collapsing into a translucent overlay in split-based detail views.

## [0.1.1] — 2026-06-22

### Changed
- Builds are now signed with **Developer ID** and **notarized by Apple**, so they install
  without Gatekeeper warnings.

## [0.1.0] — 2026-06-22

### Added
- Initial release: **text, image, and folder comparison**, **3-way merge**, a **git
  repository browser**, and the **Custom Comparison** popover with saved comparisons.
- Native SwiftUI + Liquid Glass, **zero third-party dependencies**.
- GitHub Actions release workflow that builds and attaches a drag-to-Applications `.dmg`.

[Unreleased]: https://github.com/yennster/differentialis/compare/v0.1.6...HEAD
[0.1.6]: https://github.com/yennster/differentialis/releases/tag/v0.1.6
[0.1.5]: https://github.com/yennster/differentialis/releases/tag/v0.1.5
[0.1.4]: https://github.com/yennster/differentialis/releases/tag/v0.1.4
[0.1.3]: https://github.com/yennster/differentialis/releases/tag/v0.1.3
[0.1.2]: https://github.com/yennster/differentialis/releases/tag/v0.1.2
[0.1.1]: https://github.com/yennster/differentialis/releases/tag/v0.1.1
[0.1.0]: https://github.com/yennster/differentialis/releases/tag/v0.1.0

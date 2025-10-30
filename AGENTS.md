# Repository Guidelines

## Project Structure & Module Organization
- `anchor/anchorApp.swift` boots the SwiftUI app and wires the initial scene.
- `anchor/ContentView.swift` hosts navigation, calendar layout, and check-in grid; supporting views live alongside it.
- `anchor/CalendarSection.swift` renders the monthly calendar UI and related date math.
- `anchor/CheckInItem.swift` defines the lightweight model for sample check-in badges.
- `anchor/SettingsView.swift` is a placeholder destination for future preferences.
- `anchor/Assets.xcassets/` contains any shared imagery or color assets.

## Build, Test, and Development Commands
- `open anchor.xcodeproj` — launch the project in Xcode for editing, previews, and simulator runs.
- `xcodebuild -scheme anchor -destination 'platform=iOS Simulator,name=iPhone 16' build` — command-line build identical to Xcode’s default scheme.
- `xcodebuild -scheme anchor test -destination 'platform=iOS Simulator,name=iPhone 16'` — execute UI/unit tests once they exist.
- `swift format --in-place anchor` — run SwiftFormat (install via Mint/Homebrew) to keep Swift files consistent.

## Coding Style & Naming Conventions
- Stick to Swift API Design Guidelines: UpperCamelCase for types (`CheckInItem`), lowerCamelCase for properties/functions, and descriptive enum cases.
- Use four-space indentation and keep modifiers on the same line as the declaration (Xcode default).
- Group related SwiftUI subviews in the same file only when they are tightly coupled; otherwise factor into dedicated files as with `CalendarSection`.
- Prefer `Color` assets or semantic system colors for theming to preserve light/dark support.

## Testing Guidelines
- Add new SwiftUI previews for every major view (`#Preview` blocks) and verify in both light and dark appearances.
- When introducing logic, back it with XCTest cases under `anchorTests/` (create if absent). Mirror the filename of the source type, e.g., `CheckInStoreTests.swift`.
- Favor deterministic date handling in tests by injecting calendars or clocks.

## Commit & Pull Request Guidelines
- Follow conventional, imperative commit subjects (`Add monthly calendar grid`, `Refine dark-mode palette`).
- Keep commits scoped to one logical change and include before/after screenshots for UI adjustments in PR descriptions.
- Reference related issues with `Fixes #123` or `Refs #123` and summarize testing steps (simulator/device models) before requesting review.

# SimpleFramework

SimpleFramework is a reusable Swift package for open source SwiftUI apps.
It centralizes shared components, store infrastructure, and HealthKit helpers used across:

- `SimpleHydrationTracker`
- `SimpleWeightTracker`
- `SimpleRunningTracker`
- `SimpleShoppingList`

The goal is to keep app projects focused on feature logic while shared UI and services live in one place.

## What It Includes

- Reusable SwiftUI components (`SimpleRouteRow`, `SimpleSelectableCardRow`, `SimpleFormActionButtons`, etc.)
- Shared JSON store infrastructure (`JSONEntityStore`, `JSONValueStore`, codecs, path resolver, errors)
- Shared HealthKit service and model abstractions
- Shared protocols for dependency injection and clean architecture layering

See `files.md` for the current extraction map and candidate files.

## Requirements

- Swift 6.2
- iOS 17+
- macOS 14+
- Xcode with Swift Package Manager support

## Installation

### Option 1: Add in Xcode

1. Open your app project in Xcode.
2. Go to `File -> Add Package Dependencies...`
3. Enter your SimpleFramework repository URL.
4. Choose the version or branch you want.
5. Add the `SimpleFramework` product to your app target.

### Option 2: Add in `Package.swift`

```swift
dependencies: [
    .package(url: "https://github.com/davidthorn/SimpleFramework.git", from: "0.3.0")
],
targets: [
    .target(
        name: "YourApp",
        dependencies: [
            .product(name: "SimpleFramework", package: "SimpleFramework")
        ]
    )
]
```

### Option 3: Local Package During Development

Use a local path while developing across multiple repositories:

```swift
.package(path: "../SimpleFramework")
```

## Usage

Import the module:

```swift
import SimpleFramework
```

Example shared UI component:

```swift
SimpleRouteRow(
    title: "Units",
    subtitle: "Metric",
    systemImage: "ruler",
    tint: .blue
)
```

Example shared store:

```swift
let store = JSONEntityStore<MyEntity>(
    fileName: "entities.json",
    filePathResolver: StoreFilePathResolver()
)
```

## Contributing

Contributions are welcome, especially from maintainers of open source SwiftUI apps with overlapping patterns.

### Contribution Guidelines

1. Keep shared code app-agnostic. Do not add feature logic that belongs to a single app domain.
2. Prefer protocol-backed services and stores.
3. Keep public APIs documented and stable.
4. Keep platform support compatible with package minimums (`iOS 17`, `macOS 14`).
5. Update `files.md` when extracting or promoting shared code.

### Suggested Workflow

1. Open an issue describing the shared candidate and expected API shape.
2. Implement in `Sources/SimpleFramework`.
3. Replace duplicated app-side code in at least one consumer app.
4. Add or update tests when behavior is non-trivial.
5. Open a pull request with migration notes.

## Versioning

Use semantic versioning:

- Patch: bug fixes and internal improvements
- Minor: backward-compatible API additions
- Major: breaking API changes

## License

This project is licensed under the terms in `LICENSE`.

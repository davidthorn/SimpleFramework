# SimpleFramework

SimpleFramework is a shared Swift package used by multiple app projects to avoid duplicating UI, storage, and HealthKit integration code.

This README is an integration manual: what to use, when to use it, and how to wire it into an app.

## Who This Is For

Use this package when your app needs one or more of:

- Reusable SwiftUI components for settings/forms.
- Route map rendering for outdoor activities (run, walk, cycle, hike).
- Generic JSON persistence stores.
- HealthKit permission/status UI and sync service abstractions.

## Platform and Toolchain

- Swift tools: `6.2`
- iOS: `17+`
- macOS: `14+`

## Installation

### Xcode

1. Open your app project.
2. `File` -> `Add Package Dependencies...`
3. Add this repository URL: `https://github.com/davidthorn/SimpleFramework.git`
4. Select a version/branch.
5. Link product: `SimpleFramework`.

### Package.swift

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

### Local development

```swift
.package(path: "../SimpleFramework")
```

## Quick Start

```swift
import SimpleFramework
```

Start with one shared component, then move app-specific duplicates over in small steps.

## Folder Structure Rules

Place files by domain first, then by responsibility. This keeps related APIs discoverable and prevents feature leakage.

- `Sources/SimpleFramework/Components`: shared SwiftUI views used directly by apps.
- `Sources/SimpleFramework/Components/HealthKit`: HealthKit-specific UI (`SimpleHealthKitPermissionsCard`, etc.).
- `Sources/SimpleFramework/Components/Maps`: map/route UI (`MapRouteView`, `MapExpandableRouteView`, overlays/placeholders).
- `Sources/SimpleFramework/Components/Workouts`: workout-focused UI that is still app-agnostic.
- `Sources/SimpleFramework/Models`: shared domain models.
- `Sources/SimpleFramework/Models/HealthKit`: HealthKit model types.
- `Sources/SimpleFramework/Models/Maps`: route/map model types (`RoutePoint`, `RouteStatItem`).
- `Sources/SimpleFramework/Models/Preferences`: reusable settings/units models.
- `Sources/SimpleFramework/Models/Reminder`: reminder scheduling and authorization models.
- `Sources/SimpleFramework/Models/Workouts`: workout summary/detail data models.
- `Sources/SimpleFramework/Services`: business/service layer entry points.
- `Sources/SimpleFramework/Services/HealthKit`: HealthKit service implementations.
- `Sources/SimpleFramework/Services/Preferences`: preferences-related services.
- `Sources/SimpleFramework/Services/Reminder`: reminder/notification services.
- `Sources/SimpleFramework/Services/Maps`: map-domain services (create this first when adding shared map service logic).
- `Sources/SimpleFramework/Protocols`: public contracts for dependency injection.
- `Sources/SimpleFramework/Stores`: persistence implementations (`JSONEntityStore`, `JSONValueStore`, infra helpers).
- `Sources/SimpleFramework/Errors`: typed errors grouped by domain.
- `Sources/SimpleFramework/Helpers`: pure helpers/builders that support models/services without owning app state.

When deciding file placement:

1. Put the file in the narrowest reusable domain folder that matches its responsibility.
2. If a domain folder does not exist yet and the code is clearly reusable, create it under the correct top-level type (`Components`, `Models`, `Services`, etc.).
3. Do not place app-specific feature code in this package, even if technically compatible.

## Preview Rules

All SwiftUI views in this package must include previews that are safe and useful for development.

1. Every `View` must include at least one preview.
2. All preview code must be wrapped in `#if DEBUG` so preview-only code never ships in release builds.
3. Preview state/data should be deterministic and local to the file (no network, no production service calls).
4. If a view depends on bindings, provide realistic `.constant(...)` preview values.
5. If a view requires callbacks, provide no-op closures in previews unless interaction behavior is being demonstrated.
6. Keep previews compile-safe and self-contained; avoid hidden dependencies on app targets.
7. When a view has multiple major states (empty/loading/error/content), include representative previews for those states.

## Core Usage Patterns

### 1) Settings row/navigation affordance

Use `SimpleRouteRow` for tappable settings-style rows.

```swift
SimpleRouteRow(
    title: "Units",
    subtitle: "Metric",
    systemImage: "ruler",
    tint: .blue
)
```

### 2) Form fields: primitives vs wrapped cards

The field APIs are intentionally split into two layers.

- `Form*` components are the lower-level form primitives.
- `Simple*` components are wrapper components that add the outer card/section treatment used by the apps.

Use the `Form*` layer when you need direct control over form composition:

- `FormTextFieldRowView`
- `FormTextEditorRowView`
- `FormFieldLabelView`
- `FormTextFieldRowStyle`
- `FormTextEditorRowStyle`

These types own:

- the label row
- optional `description`
- optional `trailingLabel`
- validation message
- input behavior and input styling

They do not own the outer padded card wrapper.

Use the `Simple*` layer when you want the shared app-ready card presentation without rebuilding the wrapper each time:

- `SimpleLabeledTextFieldCard`
- `SimpleLabeledTextEditorCard`

These wrappers sit on top of the `Form*` primitives and add:

- outer padding
- outer card background
- outer card border treatment
- the simpler app-facing API used in most screens

Rule of thumb:

1. Use `Form*` when building form layouts directly.
2. Use `Simple*` when you want the standard shared card look.
3. If a field and editor should visually match in app screens, use the matching `Simple*` wrappers together.

### 3) Route map rendering (activity-agnostic)

Use `RoutePoint` for route coordinates and `MapRouteView` for map drawing.

```swift
let points: [RoutePoint] = [
    RoutePoint(
        latitude: 37.3346,
        longitude: -122.0090,
        altitude: 12,
        speedMetersPerSecond: 2.8,
        courseDegrees: 70,
        timestamp: Date()
    )
]

MapRouteView(
    points: points,
    currentPoint: points.last,
    showsUserLocation: true
)
```

Use `MapExpandableRouteView` when you want collapsed + full-screen map behavior and optional overlay stats:

```swift
MapExpandableRouteView(
    points: points,
    currentPoint: points.last,
    showsUserLocation: true,
    overlayStats: [
        RouteStatItem(title: "Distance", value: "3.2 km"),
        RouteStatItem(title: "Pace", value: "5:20 /km")
    ]
)
```

### 4) HealthKit permissions and auto-sync UI

Use shared cards to keep permission and sync UX consistent across apps.

```swift
SimpleHealthKitPermissionsCard(
    permissionState: HealthKitPermissionState(read: .authorized, write: .denied),
    statusSummaryText: "Read is authorized, write is denied.",
    isHealthKitAvailable: true,
    onRequestAccess: { /* request HealthKit */ },
    onOpenSettings: { /* open app settings */ }
)
```

```swift
SimpleHealthKitAutoSyncCard(
    isAutoSyncEnabled: $isAutoSyncEnabled,
    isHealthKitAvailable: isHealthKitAvailable
)
```

### 5) JSON persistence

Use `JSONEntityStore` for `Identifiable` entity collections and `JSONValueStore` for singular values.

```swift
let store = JSONEntityStore<MyEntity>(
    fileName: "entities.json",
    filePathResolver: StoreFilePathResolver()
)
```

Stores are actor-based and expose async APIs and streams for observation.

## What To Put In This Package

Add code here when all are true:

1. It is reused (or about to be reused) across multiple apps.
2. It is app-agnostic.
3. Public API is stable enough for downstream use.

Keep app-specific feature logic in the app repositories.

## Contribution Workflow

1. Propose the shared candidate and target API.
2. Extract into `Sources/SimpleFramework`.
3. Replace one real app usage first.
4. Validate compile and runtime behavior in consuming apps.
5. Document migration impact if public names changed.

Keep changes focused and incremental to reduce migration risk.

## License

See `LICENSE`.

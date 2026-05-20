# Flutter Project — Setup

Environment and dependency setup for local development.

---

## Prerequisites

- macOS, Windows, or Linux
- IDE with Flutter support (VS Code, Android Studio, or Cursor)
- A running emulator or physical device

---

## Setup Instructions

### Step 1: Install FVM (Flutter Version Management)

FVM manages Flutter SDK versions. This project uses **Flutter 3.38.1**.

#### macOS (using Homebrew)
```bash
brew tap leoafarias/fvm
brew install fvm
```

#### macOS/Linux (using pub)
```bash
dart pub global activate fvm
```

#### Windows (using Chocolatey)
```bash
choco install fvm
```

#### Windows (using pub)
```bash
dart pub global activate fvm
```

> **Note**: If using `dart pub global activate`, add `~/.pub-cache/bin` to your PATH.

### Step 2: Install Flutter SDK via FVM

From the project directory:

```bash
cd flutter_project
fvm install 3.38.1
fvm use 3.38.1
```

### Step 3: Install Dependencies

```bash
fvm flutter pub get
```

### Step 4: Verify Setup

```bash
fvm flutter --version
```

Expected:

```
Flutter 3.38.1 • channel stable
```

---

## Running the App

### Run on emulator or device
```bash
fvm flutter run
```

### Run tests
```bash
fvm flutter test
```

---

## Project Structure

```
lib/
├── main.dart                           # App entry point
└── packages/
    ├── core/
    │   ├── network/                    # API client & networking
    │   │   ├── api_client.dart
    │   │   ├── api_exception.dart
    │   │   ├── api_response.dart
    │   │   └── network.dart            # Barrel export
    │   ├── logger/                     # Logging utilities
    │   │   ├── app_logger.dart
    │   │   └── logger.dart             # Barrel export
    │   └── analytics/                  # Analytics service
    │       ├── analytics_service.dart
    │       └── analytics.dart          # Barrel export
    └── design/
        └── design_system/              # Design tokens & components
            ├── tokens/
            │   ├── app_colors.dart
            │   └── app_spacing.dart
            └── design_system.dart      # Barrel export

test/
└── widget_test.dart
```

---

## Available Dependencies

### State Management
- `flutter_bloc` — BLoC pattern
- `equatable` — Value equality for BLoC states/events

### Dependency Injection
- `get_it` — Service locator

### Networking
- `dio` — HTTP client

### UI
- `cached_network_image` — Image caching and loading

### Testing
- `bloc_test` — BLoC testing utilities
- `mocktail` — Mocks for tests

---

## Pre-built Packages

### Network layer
```dart
import 'package:flutter_project/packages/core/network/network.dart';

final apiClient = ApiClient(Dio());
final response = await apiClient.get('/products');
```

### Logger
```dart
import 'package:flutter_project/packages/core/logger/logger.dart';

AppLogger.info('User action completed');
AppLogger.debug('API Response: $data');
AppLogger.error('Failed to load', error: e, stackTrace: st);
```

### Analytics
```dart
import 'package:flutter_project/packages/core/analytics/analytics.dart';

AnalyticsService.instance.trackScreenView('ProductList');
AnalyticsService.instance.trackEvent('product_selected', parameters: {'id': 1});
```

### Design system
```dart
import 'package:flutter_project/packages/design/design_system/design_system.dart';

// Colors
Container(color: AppColors.primary);

// Spacing
Padding(padding: EdgeInsets.all(AppSpacing.md));
```

---

## Troubleshooting

### FVM not found
```bash
fvm --version

# If using pub global, add to PATH
export PATH="$PATH:$HOME/.pub-cache/bin"
```

### Flutter SDK not found
```bash
fvm install 3.38.1
fvm use 3.38.1
```

### Dependencies not resolving
```bash
fvm flutter clean
fvm flutter pub get
```

---

Use `fvm flutter` (not plain `flutter`) so the project’s pinned SDK is always used.

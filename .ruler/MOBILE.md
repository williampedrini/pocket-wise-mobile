# 🚀 Flutter Standards

## 🏗️ Architecture

**Clean Architecture + BLoC** — dependencies flow inward only!

```
📱 presentation/ → 💎 domain/ ← 📡 data/
```

## 📁 Structure
```
lib/
├── core/           # 🔧 Constants, themes, errors
└── features/
    └── [feature]/
        ├── data/           # 📡 Models, datasources, repos impl
        ├── domain/         # 💎 Entities, use cases, repo interfaces
        └── presentation/   # 🎨 BLoC, pages, widgets
```

## 🎨 UI Theme
- Primary: Purple gradient `#667EEA` → `#B794F6`
- 💚 Income green `#10B981` | 🔴 Expense red `#EF4444`
- Card-based UI with rounded corners + shadows
- Material Design 3

## ✅ Rules
- 📦 One BLoC per feature (sealed events/states)
- 🔌 Constructor injection, no direct deps
- 🧱 Models extend Entities
- 📝 Use `const` constructors
- 🇵🇹 EUR currency, PT IBANs
- 📥 **Relative imports only** → see [IMPORTS.md](IMPORTS.md)

## 📦 Import Standards

### ✅ Use Relative Imports

Always use **relative imports** for project files:

```dart
// ✅ CORRECT
import '../domain/entities/account.dart';
import '../../core/theme/app_theme.dart';

// ❌ WRONG
import 'package:pocketwise/features/account/domain/entities/account.dart';
```

### 📋 Import Order

```dart
// 1️⃣ Dart SDK
import 'dart:convert';
import 'dart:async';

// 2️⃣ Flutter SDK
import 'package:flutter/material.dart';

// 3️⃣ External packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

// 4️⃣ Project files (relative)
import '../../domain/entities/account.dart';
import '../bloc/account_bloc.dart';
```

### 🎯 Why Relative?

- 🔄 Easier refactoring
- 📖 Clearer layer relationships
- 🚫 Avoids circular dependency confusion
- ✨ Consistent across the codebase

## ⚡ Commands
```bash
flutter pub get     # 📥 Install
flutter run         # ▶️ Run
flutter analyze     # 🔍 Lint
```

## 🧪 Testing
- `bloc_test` + `mocktail`
- Mirror `lib/` in `test/`
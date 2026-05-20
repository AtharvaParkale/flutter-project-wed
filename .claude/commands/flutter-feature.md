---
description: Scaffold a new Flutter feature using Clean Architecture (http + BLoC + GetIt + SharedPreferences). Generates all layers — Domain, Data, Presentation — and wires DI.
argument-hint: "e.g. 'products feature from GET /api/v1/products' or just 'posts'"
---

# Flutter Clean Architecture Feature Scaffold

You are scaffolding a new Flutter feature following a strict Clean Architecture pattern.
The stack is: `http` (networking), `bloc` + `flutter_bloc` (state management), `get_it` (DI), `shared_preferences` (local cache).

Initial request: $ARGUMENTS

---

## Step 1 — Gather Requirements

If $ARGUMENTS is empty or missing any of the following, use AskUserQuestion to collect them before writing any files:

- **Feature name** (snake_case, e.g. `products`) — used for folder names, class prefixes
- **Entity name** (PascalCase, e.g. `Product`) — the main domain object
- **API endpoint** — full URL or path, e.g. `https://api.example.com/products`
- **JSON fields** — list every field with its type as it appears in the API response (e.g. `id: int, title: String, price: double, isAvailable: bool`)
- **List or single object?** — does the endpoint return a JSON array `[...]` or a single object `{...}`?
- **Include SharedPreferences cache?** — yes/no (default yes)
- **Package name** — the Flutter package name from pubspec.yaml (e.g. `my_app`) — needed for imports

Once you have all the above, proceed.

---

## Step 2 — Locate DI Container

Before generating files, use Bash or Read to find the GetIt init file:

```bash
find lib -name "init_dependencies.dart" | head -5
# or
grep -r "GetIt.instance" lib --include="*.dart" -l
```

Read that file fully so you can append to it later. Also check whether `lib/commons/usecase.dart` exists.

---

## Step 3 — Generate Files

Use the Write tool to create **every file below**, substituting:
- `{feature}` → snake_case feature name (e.g. `products`)
- `{Feature}` → PascalCase feature name (e.g. `Products`)
- `{entity}` → snake_case entity name (e.g. `product`)
- `{Entity}` → PascalCase entity name (e.g. `Product`)
- `{packageName}` → the Flutter package name
- `{fields}` → the actual fields the user provided
- `{endpoint}` → the full API URL

### 3.0 — UseCase Base (only if `lib/commons/usecase.dart` does not exist)

**`lib/commons/usecase.dart`**
```dart
abstract interface class UseCase<T, NoParams> {
  Future<T> call(params);
}

class NoParams {}
```

---

### 3.1 — Domain Layer

**`lib/features/{feature}/domain/entities/{Entity}.dart`**
```dart
class {Entity} {
  final int id;
  // Add all fields from user input here — example below:
  // final String title;
  // final double price;

  {Entity}({
    required this.id,
    // required this.title,
    // required this.price,
  });
}
```

**`lib/features/{feature}/domain/repositories/{feature}_repository.dart`**
```dart
import 'package:{packageName}/features/{feature}/domain/entities/{Entity}.dart';

abstract interface class {Feature}Repository {
  Future<List<{Entity}>> getAll{Entity}s();
}
```

**`lib/features/{feature}/domain/usecases/get_{entity}s_usecase.dart`**
```dart
import 'package:{packageName}/commons/usecase.dart';
import 'package:{packageName}/features/{feature}/domain/entities/{Entity}.dart';
import 'package:{packageName}/features/{feature}/domain/repositories/{feature}_repository.dart';

class Get{Entity}sUseCase implements UseCase<List<{Entity}>, NoParams> {
  final {Feature}Repository _{feature}Repository;

  Get{Entity}sUseCase({required {Feature}Repository {feature}Repository})
      : _{feature}Repository = {feature}Repository;

  @override
  Future<List<{Entity}>> call(params) async {
    return await _{feature}Repository.getAll{Entity}s();
  }
}
```

---

### 3.2 — Data Layer

**`lib/features/{feature}/data/models/{Entity}Model.dart`**
```dart
import 'package:{packageName}/features/{feature}/domain/entities/{Entity}.dart';

class {Entity}Model extends {Entity} {
  {Entity}Model({
    required super.id,
    // required super.title,
    // required super.price,
  });

  factory {Entity}Model.fromJson(Map<String, dynamic> json) {
    return {Entity}Model(
      id: json['id'] as int,
      // title: json['title'] as String,
      // price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // 'title': title,
      // 'price': price,
    };
  }
}
```

**`lib/features/{feature}/data/datasources/remote_datasource.dart`**
```dart
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:{packageName}/features/{feature}/data/models/{Entity}Model.dart';

abstract interface class {Feature}RemoteDataSource {
  Future<List<{Entity}Model>> getAll{Entity}s();
}

class {Feature}RemoteDatasourceImpl implements {Feature}RemoteDataSource {
  @override
  Future<List<{Entity}Model>> getAll{Entity}s() async {
    try {
      final response = await http.get(
        Uri.parse('{endpoint}'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('HTTP \${response.statusCode}: \${response.reasonPhrase}');
      }

      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => {Entity}Model.fromJson(item)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}
```

**`lib/features/{feature}/data/datasources/local_datasource.dart`**

(Only generate this file if the user wants SharedPreferences caching)

```dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:{packageName}/features/{feature}/data/models/{Entity}Model.dart';

abstract interface class {Feature}LocalDataSource {
  Future<List<{Entity}Model>> getAll{Entity}s();
  Future<void> saveAll{Entity}s(List<{Entity}Model> items);
}

class {Feature}LocalDataSourceImpl implements {Feature}LocalDataSource {
  static const _key = '{entity}s';

  @override
  Future<List<{Entity}Model>> getAll{Entity}s() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_key);
      if (jsonString == null) return [];
      final List<dynamic> data = jsonDecode(jsonString);
      return data.map((item) => {Entity}Model.fromJson(item)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> saveAll{Entity}s(List<{Entity}Model> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(items.map((i) => i.toJson()).toList());
      await prefs.setString(_key, encoded);
    } catch (e) {
      throw Exception('Failed to save {entity}s: \$e');
    }
  }
}
```

**`lib/features/{feature}/data/repository/{feature}_repository_impl.dart`**

(Adapt the imports and constructor based on whether caching is included)

```dart
import 'package:{packageName}/features/{feature}/data/datasources/remote_datasource.dart';
import 'package:{packageName}/features/{feature}/data/datasources/local_datasource.dart';
import 'package:{packageName}/features/{feature}/domain/entities/{Entity}.dart';
import 'package:{packageName}/features/{feature}/domain/repositories/{feature}_repository.dart';

class {Feature}RepositoryImpl implements {Feature}Repository {
  final {Feature}RemoteDataSource _remoteDataSource;
  final {Feature}LocalDataSource _localDataSource;

  {Feature}RepositoryImpl({
    required {Feature}RemoteDataSource remoteDataSource,
    required {Feature}LocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<List<{Entity}>> getAll{Entity}s() async {
    try {
      // Cache-first strategy — comment out local blocks to go network-only
      final cached = await _localDataSource.getAll{Entity}s();
      if (cached.isNotEmpty) return cached;

      final remote = await _remoteDataSource.getAll{Entity}s();
      await _localDataSource.saveAll{Entity}s(remote);

      return remote.map((item) => item as {Entity}).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}
```

---

### 3.3 — Presentation Layer

**`lib/features/{feature}/presentation/bloc/{feature}_event.dart`**
```dart
part of '{feature}_bloc.dart';

@immutable
sealed class {Feature}Event {}

class GetAll{Entity}sEvent extends {Feature}Event {}
```

**`lib/features/{feature}/presentation/bloc/{feature}_state.dart`**
```dart
part of '{feature}_bloc.dart';

@immutable
sealed class {Feature}State {}

final class {Feature}Initial extends {Feature}State {}

final class {Feature}LoadingState extends {Feature}State {}

final class {Feature}SuccessState extends {Feature}State {
  final List<{Entity}> items;
  {Feature}SuccessState({required this.items});
}

final class {Feature}ErrorState extends {Feature}State {
  final String message;
  {Feature}ErrorState({this.message = 'Something went wrong'});
}
```

**`lib/features/{feature}/presentation/bloc/{feature}_bloc.dart`**
```dart
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:{packageName}/commons/usecase.dart';
import 'package:{packageName}/features/{feature}/domain/entities/{Entity}.dart';
import 'package:{packageName}/features/{feature}/domain/usecases/get_{entity}s_usecase.dart';

part '{feature}_event.dart';
part '{feature}_state.dart';

class {Feature}Bloc extends Bloc<{Feature}Event, {Feature}State> {
  final Get{Entity}sUseCase _get{Entity}sUseCase;

  {Feature}Bloc({required Get{Entity}sUseCase get{Entity}sUseCase})
      : _get{Entity}sUseCase = get{Entity}sUseCase,
        super({Feature}Initial()) {
    on<GetAll{Entity}sEvent>(_onGetAll{Entity}s);
  }

  Future<void> _onGetAll{Entity}s(
    GetAll{Entity}sEvent event,
    Emitter<{Feature}State> emit,
  ) async {
    try {
      emit({Feature}LoadingState());
      final items = await _get{Entity}sUseCase.call(NoParams());
      emit({Feature}SuccessState(items: items));
    } catch (e) {
      emit({Feature}ErrorState(message: e.toString()));
    }
  }
}
```

**`lib/features/{feature}/presentation/ui/screens/{feature}_screen.dart`**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{packageName}/dependency_manager/init_dependencies.dart';
import 'package:{packageName}/features/{feature}/presentation/bloc/{feature}_bloc.dart';

class {Feature}Screen extends StatelessWidget {
  const {Feature}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<{Feature}Bloc>()..add(GetAll{Entity}sEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('{Feature}')),
        body: BlocConsumer<{Feature}Bloc, {Feature}State>(
          listener: (context, state) {
            if (state is {Feature}ErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is {Feature}LoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is {Feature}SuccessState) {
              return ListView.builder(
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return ListTile(
                    title: Text(item.id.toString()),
                    // Replace with actual entity fields
                  );
                },
              );
            }
            if (state is {Feature}ErrorState) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
```

---

## Step 4 — Update Dependency Injection

Use the Edit tool to append the new registrations inside the existing `initDependencies()` function, following the cascade `..registerFactory` pattern already in the file.

Add (in order — datasources first, then repo, then usecase, then bloc):

```dart
// {Feature} feature
..registerFactory<{Feature}RemoteDataSource>(() => {Feature}RemoteDatasourceImpl())
..registerFactory<{Feature}LocalDataSource>(() => {Feature}LocalDataSourceImpl())
..registerFactory<{Feature}Repository>(
  () => {Feature}RepositoryImpl(
    remoteDataSource: serviceLocator(),
    localDataSource: serviceLocator(),
  ),
)
..registerFactory<Get{Entity}sUseCase>(
  () => Get{Entity}sUseCase({feature}Repository: serviceLocator()),
)
..registerFactory<{Feature}Bloc>(
  () => {Feature}Bloc(get{Entity}sUseCase: serviceLocator()),
)
```

Add the required imports at the top of the DI file too.

---

## Step 5 — Summary

After all files are written, print a file tree like this:

```
Created {feature} feature:

lib/features/{feature}/
├── domain/
│   ├── entities/{Entity}.dart
│   ├── repositories/{feature}_repository.dart
│   └── usecases/get_{entity}s_usecase.dart
├── data/
│   ├── models/{Entity}Model.dart
│   ├── datasources/remote_datasource.dart
│   ├── datasources/local_datasource.dart
│   └── repository/{feature}_repository_impl.dart
└── presentation/
    ├── bloc/{feature}_bloc.dart
    ├── bloc/{feature}_event.dart
    ├── bloc/{feature}_state.dart
    └── ui/screens/{feature}_screen.dart

Updated:
  lib/dependency_manager/init_dependencies.dart

Usage:
  Navigator.push(context, MaterialPageRoute(builder: (_) => const {Feature}Screen()));

Next steps:
  1. Fill in entity fields in {Entity}.dart and {Entity}Model.dart
  2. Run: flutter analyze
```

---

## Important Rules

- **Never skip a file** — generate every file even if some fields are placeholders.
- **Imports must use the actual package name** — always check pubspec.yaml if unsure.
- **DI cascade order** — datasources → repository → usecase → bloc (dependencies must be registered before dependents).
- **Part directives** — `{feature}_event.dart` and `{feature}_state.dart` use `part of '{feature}_bloc.dart'`, not standalone imports.
- **No `registerSingleton` for BLoC** — always use `registerFactory` so each screen gets a fresh instance (matching the existing pattern).
- **Cache strategy is opt-in** — if user said no caching, skip `local_datasource.dart`, remove it from the repository constructor, and go network-only.
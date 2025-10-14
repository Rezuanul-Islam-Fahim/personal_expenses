# Copilot Instructions for Personal Expenses App

## Project Overview
This is a Flutter 3.24+ personal expense tracking app with SQLite persistence, featuring a 7-day chart visualization and adaptive layouts for portrait/landscape orientations.

## Architecture & Data Flow

### State Management Pattern
- **Stateful HomeScreen** (`main.dart`) manages all database operations and app state
- No external state management library - uses `setState()` for UI updates
- Database operations are `async/await` with `Future<void>` and `Future<List<Expense>>`
- Pattern: UI trigger → DB operation → `_loadTransactions()` → `setState()` → rebuild

### Database Layer (SQLite via sqflite)
- **Single database file**: `expenses.db` in device's default database path
- **Schema**: `expenses` table with `id` (INTEGER PK AUTOINCREMENT), `title` (TEXT), `amount` (REAL), `date` (TEXT)
- **Database access pattern**: Every operation calls `_getDatabase()` which handles `onCreate` migration
- **CRUD operations** in `main.dart`:
  - `_getTransactions()`: SELECT all expenses, map to `List<Expense>`
  - `_addNewTx()`: INSERT via transaction block with `txn.rawInsert()`
  - `_deleteTransaction()`: DELETE by id with `db.rawDelete()`
- Always call `_loadTransactions()` after mutations to refresh UI state

### Widget Hierarchy
```
PersonalExpenses (MaterialApp)
└── HomeScreen (StatefulWidget)
    ├── Chart (7-day grouped expenses)
    │   └── ChartBar (individual day bar)
    ├── TransactionList (ListView.builder)
    │   └── TxListItem (Dismissible with delete dialogue)
    └── AddTransaction (modal bottom sheet)
```

## Key Conventions

### Theme & Styling
- **Theme defined once** in `theme.dart` as `appTheme` getter
- **Custom fonts**: OpenSans (AppBar titles), Quicksand (body text)
- **Global UI helpers** in `global.dart`:
  - `addTxField()` - rounded input decoration for forms
  - `chartbarFontPortrait()` / `chartbarFontLandscape()` - adaptive text styles
- Primary color: `Colors.indigo`, accent: `Colors.blueGrey`
- Background: `Colors.grey[200]`

### Responsive Design Pattern
- **Orientation detection**: `MediaQuery.of(context).orientation == Orientation.landscape`
- **Separate builders**: `_buildPortrait()` and `_buildLandscape()` return `List<Widget>`
- **Landscape-specific**: Toggle switch to show/hide chart (`showChart` state)
- **Body height calculation**: `mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top`
- Height percentages differ per orientation:
  - Portrait: 30% chart, 70% list
  - Landscape: 10% switch, 80% chart OR 90% list

### Modal Bottom Sheet Pattern
- Use `showModalBottomSheet()` for user input forms (e.g., `AddTransaction`)
- Widget receives callback function as constructor parameter (e.g., `_addNewTx`)
- Call `Navigator.of(context).pop()` after successful submission
- **Keyboard handling**: Wrap in `SingleChildScrollView` with padding:
  ```dart
  padding: EdgeInsets.only(
    bottom: MediaQuery.of(context).viewInsets.bottom + 60,
  )
  ```

### Date Handling
- Store dates as ISO 8601 strings in DB: `date.toString()` / `DateTime.parse()`
- Display with `intl` package: `DateFormat('dd/MM/yy').format(date)`
- Chart uses `DateFormat.E().format(date).substring(0, 1)` for single-letter weekdays

### Empty State
- Show `NoTransactionImage` widget when `txList.isEmpty`
- Pass `isLandscape` boolean to adjust image sizing

## Development Workflows

### Running the App
```bash
flutter run                      # Debug mode with hot reload
flutter build apk --release      # Production APK
```

### Dependencies Management
```bash
flutter pub get                  # After changing pubspec.yaml
flutter pub upgrade              # Update all dependencies
```

### Common Tasks
- **Add new expense field**: Modify `Expense` model → update DB schema version in `_getDatabase()` → add migration logic → update insert/select queries
- **Add new widget**: Create in `lib/widgets/` → import in `main.dart` → pass required callbacks
- **Update theme**: Edit `theme.dart` → restart app (theme not hot-reloadable)

## CI/CD Pipeline (GitHub Actions)

### Workflow: `build-and-deploy-appetize.yml`
- **Trigger**: Pull requests to `master` branch, manual dispatch
- **3-layer caching**: Java (Gradle), Flutter SDK, Pub dependencies
- **Build**: Universal release APK → renamed with version from `pubspec.yaml`
- **Artifacts**: 30-day retention with artifact ID for direct downloads
- **Deployment**: Uploads to Appetize.io (requires `APPETIZE_API_TOKEN` secret)
- **PR comments**: Auto-posts Appetize preview URL + artifact download link

### Version Management
- Format: `version: X.Y.Z+BUILD` in `pubspec.yaml`
- Extracted via: `grep 'version:' pubspec.yaml | awk '{print $2}'`
- APK naming: `personal_expenses-X.Y.Z+BUILD.apk`

## Critical Patterns to Follow

1. **Always use raw SQL queries** - This project uses `rawQuery`, `rawInsert`, `rawDelete` (not ORM helpers)
2. **Database transactions for writes** - Wrap INSERT/UPDATE in `db.transaction((txn) async { ... })`
3. **Null safety** - Use `!` for non-null assertions, `?` for nullable types, `??` for defaults
4. **Const constructors** - Use `const` for immutable widgets to optimize rebuilds
5. **Function callbacks** - Pass functions as `Function` type, not function references
6. **ListView optimization** - Always use `ListView.builder` for dynamic lists (never `ListView(children: [...])`
7. **MediaQuery at build** - Cache `MediaQuery.of(context)` once per build, don't call repeatedly

## File Locations

- **Models**: `lib/models/*.dart` (plain Dart classes, no `extends` or `mixins`)
- **Widgets**: `lib/widgets/*.dart` (reusable UI components)
- **Theme**: `lib/theme.dart` (single source of truth for styling)
- **Global helpers**: `lib/global.dart` (shared UI functions)
- **Main entry**: `lib/main.dart` (app + home screen + database logic)
- **Assets**: `assets/images/*.png`, `assets/fonts/*.ttf`

## Testing & Debugging

- No automated tests currently in project
- Debug SQLite: Add `print()` statements in `_getDatabase()` and CRUD methods
- Debug builds: Check widget tree with Flutter DevTools
- Production issues: Review GitHub Actions logs for build failures

## External Dependencies

- `intl ^0.19.0` - Date formatting (no timezone handling)
- `sqflite ^2.3.3` - SQLite database (Android & iOS)
- `path ^1.9.0` - Cross-platform path utilities for DB location
- `cupertino_icons ^1.0.8` - iOS-style icons
- `flutter_launcher_icons ^0.14.1` - Generate app icons (dev only)
- `flutter_native_splash ^2.4.1` - Splash screen config (dev only)

## Common Pitfalls

- **Don't forget to call `_loadTransactions()`** after DB mutations
- **Don't use `context` after async gaps** - cache it or use `mounted` check
- **Don't modify `txList` directly** - always use `setState(() => txList = ...)`
- **Don't hardcode colors** - use `Theme.of(context)` or `Colors.*` constants
- **Don't use `async` in build methods** - use `FutureBuilder` or load data in `initState()`

---

*Last updated: October 2025 | Flutter 3.35.6 | Dart 3.5.0*

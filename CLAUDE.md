# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Mission Invest is a gamified savings goal tracker (mobile-first Flutter app + Firebase backend + FastAPI AI service). Users create time-boxed "missions" (savings goals) with streaks, badges, XP, and AI-powered nudges.

## Architecture

Three independent modules with zero cross-dependencies:

- **`mission_invest_app/`** — Flutter client (Android/iOS/Web). Dart 3.11+, Riverpod 2.6.1 state management, GoRouter 14.8.1 navigation, Freezed data classes, Clean Architecture per feature.
- **`mission_invest_firebase/`** — Firebase infrastructure. Cloud Functions (TypeScript, Node 22), Firestore rules/indexes, FCM notifications. Firebase project ID: `mission-inverse`.
- **`mission_invest_ai/`** — Python FastAPI 0.115+ microservice for AI features (nudges, predictions, adaptive planning). Uses LangChain with Claude (Anthropic) as default LLM, OpenAI as fallback.

Data flow: Flutter ↔ Firestore (real-time SDK), Flutter → FastAPI (Dio + Bearer token), Cloud Functions → FastAPI (scheduled), Cloud Functions → FCM → devices.

## Build & Run Commands

### Flutter App (`mission_invest_app/`)
```bash
cd mission_invest_app
flutter pub get                          # install dependencies
dart run build_runner build              # generate Freezed/json_serializable/Riverpod code
flutter analyze                          # lint
flutter test                             # run all tests
flutter test test/path/to_test.dart      # run single test
flutter run                              # run on connected device/emulator
flutter build apk                        # Android release build
```

### Firebase Functions (`mission_invest_firebase/functions/`)
```bash
cd mission_invest_firebase/functions
npm install                              # install dependencies
npm run build                            # compile TypeScript
npm run build:watch                      # watch mode
npm run serve                            # local emulator (builds first)
npm run deploy                           # deploy to Firebase
npm run logs                             # view function logs
```

### FastAPI AI Service (`mission_invest_ai/`)
```bash
cd mission_invest_ai
pip install -r requirements.txt
cp .env.example .env                     # configure Firebase creds, API keys, CORS
uvicorn app.main:app --reload --port 8000  # local dev server
```

## Flutter App Structure

Each feature in `lib/features/` follows Clean Architecture:
```
feature_name/
  data/
    models/           # Freezed classes with fromJson
    repositories/     # Firestore implementations
  presentation/
    pages/            # Full-screen widgets (*_page.dart)
    widgets/          # Feature-specific widgets
    providers/        # Riverpod providers
```

Features: admin, ai, auth, contributions, home, missions, notifications, onboarding, profile, rewards, seasons, social, teams.

Key shared directories:
- `lib/core/constants/` — API endpoints, collection names, asset paths
- `lib/core/theme/` — 4 theme variants (dark, light, gaming, pastel)
- `lib/core/network/` — Dio client with Firebase auth interceptor
- `lib/models/` — Shared Freezed data classes (UserModel, NotificationModel)
- `lib/repositories/` — Shared repositories (UserRepository, AdminRepository)

## Cloud Functions Structure

Functions in `mission_invest_firebase/functions/src/` organized by type:
- **Triggers**: onMissionCreate, onMissionComplete, onContributionCreate, onTeamContribution
- **Scheduled**: evaluateDailyStreaks, evaluateExpiredMissions, sendDailyReminders, triggerAiNudges
- **Callable**: recoverStreak, sendBroadcast, admin analytics/templates/flags/challenges, season/team management, marketplace purchase

## AI Service Endpoints

FastAPI routes at default `http://localhost:8000` (configurable via `AI_BASE_URL` env or `String.fromEnvironment` in Flutter):
- `GET /health` — health check
- `POST /ai/nudge` — generate motivational nudge
- `POST /ai/adapt` — adaptive savings plan
- `POST /ai/predict` — contribution prediction
- `POST /ai/message` — AI chat message

LLM provider is configurable (Anthropic default, OpenAI fallback) via `.env`.

## Key Patterns

- **State management**: Riverpod v2 exclusively. StreamProvider for real-time Firestore data, FutureProvider for one-shot async, StateNotifier for stateful UI logic. `.family` modifier for parameterized providers.
- **Data classes**: Freezed + json_serializable. After modifying any model, run `dart run build_runner build`.
- **Routing**: GoRouter with auth-based redirects and onboarding guard. ShellRoute wraps bottom-nav tabs (home, missions, rewards, profile). Routes defined in `lib/app/router.dart`.
- **Firestore access**: Repository pattern with Timestamp ↔ DateTime conversion helpers.
- **Error handling**: Custom `AppException` types and `Failure` class in `lib/core/errors/`.
- **AI service auth**: Bearer token (Firebase ID token) validated in FastAPI middleware.
- **Validation**: Zod in Cloud Functions, Pydantic in FastAPI, Reactive Forms in Flutter.

## Firestore Collections

`users`, `missions`, `contributions` (immutable), `badges` (immutable), `notifications`, `templates` (public read, admin write), `challenges`, `featureFlags`, `seasons`, `teamMissions`, `marketplace`, `aiLogs` (admin only). Security rules enforce ownership via `isOwner(userId)` and admin via `isAdmin()` flag.

## Commit Convention

```
feat(scope): description
fix(scope): description
chore(scope): description
docs(scope): description
```

# Technical Design Document (TDD) — Mission Invest

> **Version:** 1.0 | **Status:** Final | **Last Updated:** April 2026

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Architecture Overview](#2-architecture-overview)
3. [Team Responsibilities & Git Workflow](#3-team-responsibilities--git-workflow)
4. [Flutter App Architecture](#4-flutter-app-architecture)
5. [Folder Structure](#5-folder-structure)
6. [Firestore Schema](#6-firestore-schema)
7. [Firestore Security Rules](#7-firestore-security-rules)
8. [Firestore Indexes](#8-firestore-indexes)
9. [Cloud Functions Spec](#9-cloud-functions-spec)
10. [FastAPI Endpoints](#10-fastapi-endpoints)
11. [Authentication Flow](#11-authentication-flow)
12. [Notification System](#12-notification-system)
13. [State Management (Riverpod)](#13-state-management-riverpod)
14. [Routing Map (GoRouter)](#14-routing-map-gorouter)
15. [Dependencies](#15-dependencies)
16. [Environment & Config](#16-environment--config)
17. [Error Handling Strategy](#17-error-handling-strategy)
18. [MVP Scope & Phases](#18-mvp-scope--phases)
19. [Admin Dashboard](#19-admin-dashboard)
20. [Naming Conventions & Coding Standards](#20-naming-conventions--coding-standards)

---

## 1. Project Overview

| Field | Value |
|-------|-------|
| **App Name** | Mission Invest |
| **Purpose** | Gamified savings goal tracker — turns financial goals into time-boxed, streak-driven missions with AI-powered nudges |
| **Target Audience** | Ages 18–32, India-first, smartphone-native |
| **Platforms** | Android, iOS, Web (admin dashboard) |
| **Team Size** | 3 developers |
| **MVP Timeline** | 25 days (5 phases) |

### Tech Stack Summary

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter (Riverpod + GoRouter) |
| Auth | Firebase Authentication |
| Database | Cloud Firestore |
| Backend Logic | Firebase Cloud Functions (TypeScript) |
| Push Notifications | Firebase Cloud Messaging (FCM) |
| File Storage | Firebase Storage |
| AI Microservice | FastAPI (Python) + LangChain |
| Admin Hosting | Firebase Hosting (Flutter Web) |

---

## 2. Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                  Flutter App (Client)                    │
│              Android / iOS / Web (Admin)                 │
└──────────┬─────────────────────┬────────────────────────┘
           │                     │
    Firebase SDK            HTTP + Bearer Token
           │                     │
┌──────────▼──────────┐   ┌──────▼──────────────────────┐
│      Firebase        │   │     FastAPI AI Service       │
│                      │   │                              │
│  Auth (login/JWT)    │   │  POST /ai/nudge              │
│  Firestore (data)    │   │  POST /ai/adapt              │
│  Storage (files)     │   │  POST /ai/predict            │
│  FCM (push)          │   │  POST /ai/message            │
│  Cloud Functions     │   │  GET  /health                │
│  Hosting (admin web) │   │                              │
└──────────────────────┘   └──────────┬───────────────────┘
                                      │
                             ┌────────▼────────┐
                             │  LLM Provider   │
                             │  (Claude / GPT)  │
                             └─────────────────┘
```

### Communication Flow

```
Flutter App  ──(Firestore SDK)──────> Cloud Firestore
Flutter App  ──(HTTP + Bearer)──────> FastAPI (AI only)
Cloud Functions ──(HTTP)────────────> FastAPI (scheduled nudges)
Cloud Functions ──(Admin SDK)───────> Firestore (streak eval, badge award)
Cloud Functions ──(FCM Admin)───────> FCM ──> Device
```

---

## 3. Team Responsibilities & Git Workflow

### Team Split

| Member | Scope | Repo/Folder |
|--------|-------|-------------|
| **Dev 1** | Flutter App (all UI, state, services, admin dashboard) | `mission_invest_app/` |
| **Dev 2** | Firebase (Cloud Functions, security rules, indexes) | `mission_invest_firebase/` |
| **Dev 3** | FastAPI AI Microservice (all `/ai/*` endpoints) | `mission_invest_ai/` |

> **Zero conflict guarantee:** Each dev works in a completely separate folder. No overlapping files.

### Git Workflow

```
main                          ← production releases
├── develop                   ← integration branch
│   ├── feature/mi-01-auth-screens        ← Dev 1
│   ├── feature/mi-02-mission-flow        ← Dev 1
│   ├── feature/mi-10-cloud-functions     ← Dev 2
│   ├── feature/mi-11-firestore-rules     ← Dev 2
│   ├── feature/mi-20-ai-nudge            ← Dev 3
│   └── feature/mi-21-ai-predict          ← Dev 3
```

### Branch Naming

```
feature/mi-<ticket>-short-description
fix/mi-<ticket>-short-description
chore/mi-<ticket>-short-description
```

### Commit Convention

```
feat(missions): add create mission flow
fix(streaks): correct timezone offset in daily check
chore(deps): update firebase_core to 3.12.1
docs(tdd): add notification system section
```

---

## 4. Flutter App Architecture

### Pattern: Feature-Based with Riverpod

Each feature folder follows this structure:

```
feature_name/
  data/
    models/           ← Freezed/JsonSerializable data classes
    repositories/     ← Firestore/API call implementations
  presentation/
    pages/            ← Full screen widgets (suffix: Page)
    widgets/          ← Feature-specific widgets
    providers/        ← Riverpod providers for this feature
```

### Key Decisions

| Decision | Choice | Reason |
|----------|--------|--------|
| State Management | Riverpod v2 + riverpod_generator | Type-safe, testable, no BuildContext dependency |
| Routing | GoRouter | Declarative, deep linking, auth redirect support |
| Data Classes | Freezed + json_serializable | Immutable models, auto-generated toJson/fromJson |
| HTTP Client | Dio | Interceptors for auth token injection |
| Forms | reactive_forms | Reactive validation, less boilerplate |
| Theme System | 4 Material 3 themes | dark, light, gaming, pastel — user-selectable |

---

## 5. Folder Structure

### 5a. Flutter App (`mission_invest_app/`)

```
lib/
├── main.dart                              ← Entry point (ProviderScope + Firebase.initializeApp)
│
├── app/
│   ├── app.dart                           ← MaterialApp.router with theme + GoRouter
│   └── router.dart                        ← GoRouter configuration
│
├── core/
│   ├── constants/
│   │   ├── app_constants.dart             ← Max missions (3), min amount (₹10), durations
│   │   ├── asset_paths.dart               ← Asset string constants
│   │   ├── api_endpoints.dart             ← FastAPI base URL, endpoint paths
│   │   └── collection_paths.dart          ← Firestore collection name constants
│   ├── theme/
│   │   ├── app_colors.dart                ← Color palettes for all 4 themes
│   │   ├── app_theme.dart                 ← ThemeData builders (dark, light, gaming, pastel)
│   │   └── theme_provider.dart            ← Riverpod provider for theme switching
│   ├── utils/
│   │   ├── date_utils.dart
│   │   ├── currency_formatter.dart        ← ₹ formatting helpers
│   │   └── validators.dart                ← Form validation helpers
│   ├── errors/
│   │   ├── app_exception.dart             ← Custom exception types
│   │   └── failure.dart                   ← Failure class for error handling
│   └── network/
│       ├── api_client.dart                ← Dio instance with interceptors
│       └── auth_interceptor.dart          ← Attaches Firebase ID token to requests
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   ├── register_page.dart
│   │       │   ├── forgot_password_page.dart
│   │       │   └── otp_verification_page.dart
│   │       ├── providers/
│   │       │   ├── auth_provider.dart
│   │       │   └── auth_state.dart
│   │       └── widgets/
│   │           └── social_login_button.dart
│   │
│   ├── onboarding/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── onboarding_page.dart
│   │       └── providers/
│   │           └── onboarding_provider.dart
│   │
│   ├── home/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── home_page.dart
│   │       ├── widgets/
│   │       │   ├── mission_card.dart
│   │       │   ├── streak_banner.dart
│   │       │   ├── quick_contribute_button.dart
│   │       │   └── recent_badges_row.dart
│   │       └── providers/
│   │           └── home_provider.dart
│   │
│   ├── missions/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── mission_model.dart       ← @freezed class
│   │   │   └── repositories/
│   │   │       └── mission_repository.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── mission_create_page.dart
│   │       │   ├── mission_detail_page.dart
│   │       │   ├── mission_list_page.dart
│   │       │   └── mission_edit_page.dart
│   │       ├── widgets/
│   │       │   ├── progress_ring.dart
│   │       │   ├── streak_counter.dart
│   │       │   ├── milestone_indicator.dart
│   │       │   ├── category_selector.dart
│   │       │   └── vision_image_picker.dart
│   │       └── providers/
│   │           ├── mission_list_provider.dart
│   │           ├── mission_detail_provider.dart
│   │           └── mission_create_provider.dart
│   │
│   ├── contributions/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── contribution_model.dart
│   │   │   └── repositories/
│   │   │       └── contribution_repository.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── log_contribution_page.dart
│   │       │   └── contribution_history_page.dart
│   │       ├── providers/
│   │       │   └── contribution_provider.dart
│   │       └── widgets/
│   │           ├── contribution_tile.dart
│   │           └── amount_input_field.dart
│   │
│   ├── rewards/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── badge_model.dart
│   │   │   └── repositories/
│   │   │       └── badge_repository.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── badges_page.dart
│   │       │   └── certificate_page.dart
│   │       ├── providers/
│   │       │   └── badges_provider.dart
│   │       └── widgets/
│   │           ├── badge_card.dart
│   │           └── certificate_widget.dart
│   │
│   ├── notifications/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── notification_repository.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── notification_settings_page.dart
│   │       └── providers/
│   │           └── notification_provider.dart
│   │
│   ├── ai/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── nudge_response.dart
│   │   │   │   ├── prediction_response.dart
│   │   │   │   ├── adapt_response.dart
│   │   │   │   └── motivation_response.dart
│   │   │   └── repositories/
│   │   │       └── ai_repository.dart
│   │   └── presentation/
│   │       ├── widgets/
│   │       │   ├── ai_nudge_card.dart
│   │       │   └── ai_suggestion_bottom_sheet.dart
│   │       └── providers/
│   │           └── ai_provider.dart
│   │
│   ├── profile/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── profile_page.dart
│   │       │   └── settings_page.dart
│   │       └── providers/
│   │           └── profile_provider.dart
│   │
│   └── admin/
│       └── presentation/
│           ├── pages/
│           │   ├── admin_dashboard_page.dart
│           │   ├── admin_users_page.dart
│           │   ├── admin_analytics_page.dart
│           │   ├── admin_templates_page.dart
│           │   ├── admin_challenges_page.dart
│           │   ├── admin_notifications_page.dart
│           │   ├── admin_feature_flags_page.dart
│           │   └── admin_ai_review_page.dart
│           ├── providers/
│           │   ├── admin_provider.dart
│           │   └── admin_analytics_provider.dart
│           └── widgets/
│               ├── stat_card.dart
│               ├── chart_widget.dart
│               └── user_table.dart
│
├── shared/
│   ├── widgets/
│   │   ├── app_button.dart
│   │   ├── app_text_field.dart
│   │   ├── app_loading.dart
│   │   ├── app_error_widget.dart
│   │   ├── bottom_nav_shell.dart
│   │   └── empty_state.dart
│   └── extensions/
│       ├── context_extensions.dart
│       ├── date_extensions.dart
│       └── string_extensions.dart
│
├── models/                                ← Shared models (user, notification)
│   ├── user_model.dart
│   └── notification_model.dart
│
└── repositories/                          ← Shared repositories
    ├── user_repository.dart
    └── admin_repository.dart

assets/
├── images/
├── icons/
└── lottie/
    ├── celebration.json
    └── streak_fire.json
```

### 5b. Firebase Backend (`mission_invest_firebase/`)

```
mission_invest_firebase/
├── firebase.json                          ← Firebase project config
├── .firebaserc                            ← Project aliases (dev/staging/prod)
├── firestore.rules                        ← Security rules
├── firestore.indexes.json                 ← Composite indexes
├── storage.rules                          ← Storage security rules
│
└── functions/
    ├── src/
    │   ├── index.ts                       ← Entry point — exports all functions
    │   ├── config.ts                      ← Environment config
    │   │
    │   ├── streaks/
    │   │   ├── evaluateStreaks.ts          ← Scheduled: daily streak evaluator
    │   │   └── recoverStreak.ts           ← Callable: streak recovery
    │   │
    │   ├── missions/
    │   │   ├── onMissionCreate.ts         ← Trigger: validate & init fields
    │   │   ├── onMissionComplete.ts       ← Trigger: award badge, cert, update user
    │   │   └── evaluateExpiredMissions.ts ← Scheduled: mark expired as failed
    │   │
    │   ├── contributions/
    │   │   └── onContributionCreate.ts    ← Trigger: update mission, check milestones
    │   │
    │   ├── badges/
    │   │   ├── awardBadge.ts              ← Helper: write badge doc
    │   │   └── checkBadgeEligibility.ts   ← Helper: check all badge conditions
    │   │
    │   ├── notifications/
    │   │   ├── sendDailyReminder.ts       ← Scheduled: 9AM daily push
    │   │   ├── sendStreakAlert.ts          ← Scheduled: 8PM evening warning
    │   │   ├── sendMilestoneNotification.ts ← Called by onContributionCreate
    │   │   ├── sendWeeklyReport.ts        ← Scheduled: Sunday digest
    │   │   ├── sendMissionComplete.ts     ← Called by onMissionComplete
    │   │   └── sendBroadcast.ts           ← Callable: admin broadcast
    │   │
    │   ├── ai/
    │   │   └── triggerAiNudge.ts          ← Scheduled: find users needing nudge
    │   │
    │   ├── admin/
    │   │   ├── getAnalytics.ts            ← Callable: aggregate stats
    │   │   ├── manageTemplates.ts         ← Callable: CRUD templates
    │   │   ├── manageFeatureFlags.ts      ← Callable: toggle flags
    │   │   └── manageChallenges.ts        ← Callable: CRUD challenges
    │   │
    │   └── utils/
    │       ├── firestore.ts               ← Admin SDK helpers
    │       ├── fcm.ts                     ← FCM send helper
    │       └── logger.ts
    │
    ├── package.json
    └── tsconfig.json
```

### 5c. FastAPI AI Microservice (`mission_invest_ai/`)

```
mission_invest_ai/
├── app/
│   ├── main.py                            ← FastAPI app, CORS, lifespan
│   ├── config.py                          ← Settings via pydantic-settings
│   │
│   ├── routers/
│   │   ├── nudge.py                       ← POST /ai/nudge
│   │   ├── adapt.py                       ← POST /ai/adapt
│   │   ├── predict.py                     ← POST /ai/predict
│   │   ├── message.py                     ← POST /ai/message
│   │   └── health.py                      ← GET /health
│   │
│   ├── schemas/
│   │   ├── nudge.py                       ← NudgeRequest, NudgeResponse
│   │   ├── adapt.py                       ← AdaptRequest, AdaptResponse
│   │   ├── predict.py                     ← PredictRequest, PredictResponse
│   │   └── message.py                     ← MessageRequest, MessageResponse
│   │
│   ├── services/
│   │   ├── prediction_service.py          ← Rule-based completion probability
│   │   ├── nudge_service.py               ← Nudge logic + LLM call
│   │   ├── adapt_service.py               ← Adaptation suggestion logic
│   │   ├── message_service.py             ← Motivational message via LLM
│   │   └── llm_service.py                 ← LangChain wrapper (Claude/GPT)
│   │
│   ├── middleware/
│   │   └── auth.py                        ← Firebase ID token verification
│   │
│   └── utils/
│       └── logger.py
│
├── tests/
│   ├── test_nudge.py
│   ├── test_adapt.py
│   ├── test_predict.py
│   └── test_message.py
│
├── .env.example
├── requirements.txt
├── Dockerfile
└── README.md
```

---

## 6. Firestore Schema

### Collection: `users/{userId}`

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `uid` | `string` | — | Firebase Auth UID (same as doc ID) |
| `displayName` | `string` | — | User's display name |
| `email` | `string` | — | Email address |
| `photoUrl` | `string?` | `null` | Profile photo URL |
| `phone` | `string?` | `null` | Phone number (if OTP auth) |
| `createdAt` | `timestamp` | `serverTimestamp()` | Account creation time |
| `updatedAt` | `timestamp` | `serverTimestamp()` | Last profile update |
| `totalMissionsCreated` | `number` | `0` | Lifetime mission count |
| `totalMissionsCompleted` | `number` | `0` | Lifetime completed count |
| `currentGlobalStreak` | `number` | `0` | Consecutive days with at least 1 contribution |
| `longestGlobalStreak` | `number` | `0` | All-time best streak |
| `totalSaved` | `number` | `0` | Lifetime total saved (INR) |
| `theme` | `string` | `"dark"` | `"dark" \| "light" \| "gaming" \| "pastel"` |
| `notificationTime` | `string` | `"09:00"` | HH:mm format |
| `notificationsEnabled` | `boolean` | `true` | Master push toggle |
| `fcmToken` | `string?` | `null` | Latest FCM device token |
| `isAdmin` | `boolean` | `false` | Admin flag (set manually in console) |
| `lastActiveAt` | `timestamp` | — | Last app open |
| `onboardingCompleted` | `boolean` | `false` | Has completed onboarding |

### Subcollection: `users/{userId}/streakRecoveries/{recoveryId}`

| Field | Type | Description |
|-------|------|-------------|
| `usedAt` | `timestamp` | When recovery was used |
| `missionId` | `string` | Which mission it was used for |
| `streakAtRecovery` | `number` | Streak value preserved |

---

### Collection: `missions/{missionId}`

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `id` | `string` | — | Document ID |
| `userId` | `string` | — | Owner's UID |
| `title` | `string` | — | User-given mission name |
| `category` | `string` | — | `"trip" \| "gadget" \| "vehicle" \| "emergency" \| "course" \| "gift" \| "custom"` |
| `targetAmount` | `number` | — | Goal amount in INR |
| `savedAmount` | `number` | `0` | Total contributed so far |
| `dailyTarget` | `number` | — | Calculated: `targetAmount / durationDays` |
| `frequency` | `string` | `"daily"` | `"daily" \| "weekly"` |
| `startDate` | `timestamp` | — | Mission start date |
| `endDate` | `timestamp` | — | Mission deadline |
| `durationDays` | `number` | — | Total days (10–180) |
| `currentStreak` | `number` | `0` | Current consecutive contribution days |
| `longestStreak` | `number` | `0` | Best streak for this mission |
| `lastContributionDate` | `timestamp?` | `null` | Date of most recent contribution |
| `missedDays` | `number` | `0` | Total missed contribution days |
| `recoveryUsedThisWeek` | `boolean` | `false` | Recovery used in current 7-day window |
| `recoveryWeekStart` | `timestamp?` | `null` | Start of current 7-day recovery window |
| `completionProbability` | `number` | `1.0` | 0.0 to 1.0 |
| `status` | `string` | `"active"` | `"active" \| "completed" \| "failed" \| "paused"` |
| `visionImageUrl` | `string?` | `null` | Firebase Storage path |
| `motivationMessage` | `string?` | `null` | Personal motivation note |
| `createdAt` | `timestamp` | `serverTimestamp()` | |
| `updatedAt` | `timestamp` | `serverTimestamp()` | |
| `completedAt` | `timestamp?` | `null` | When 100% reached |

---

### Collection: `contributions/{contributionId}`

| Field | Type | Description |
|-------|------|-------------|
| `id` | `string` | Document ID |
| `missionId` | `string` | Parent mission ID |
| `userId` | `string` | Contributor UID |
| `amount` | `number` | Amount in INR (min ₹10) |
| `date` | `timestamp` | Contribution date (normalized to date-only) |
| `streakDay` | `number` | Which streak day this contribution was on |
| `note` | `string?` | Optional note |
| `createdAt` | `timestamp` | Actual timestamp of logging |

> **Immutable:** Contributions cannot be edited or deleted once created.

---

### Collection: `badges/{badgeId}`

| Field | Type | Description |
|-------|------|-------------|
| `id` | `string` | Document ID |
| `userId` | `string` | Earner UID |
| `badgeType` | `string` | See badge types table below |
| `missionId` | `string` | Mission that triggered the badge |
| `missionTitle` | `string` | Denormalized for display |
| `earnedAt` | `timestamp` | When awarded |

**Badge Types:**

| Badge Type | Trigger Condition |
|-----------|-------------------|
| `3_day_streak` | 3 consecutive contribution days on any mission |
| `7_day_warrior` | 7 consecutive contribution days on any mission |
| `30_day_survivor` | 30 consecutive contribution days on any mission |
| `first_complete` | First ever mission reaches 100% |
| `halfway_hero` | Any mission reaches 50% of target amount |
| `speed_runner` | Mission completed before the deadline date |

> **Non-revocable:** Badges are permanent once earned. Only Cloud Functions can create badge docs.

---

### Collection: `notifications/{notificationId}`

| Field | Type | Description |
|-------|------|-------------|
| `id` | `string` | Document ID |
| `userId` | `string` | Recipient UID |
| `type` | `string` | `"daily_reminder" \| "streak_alert" \| "streak_break" \| "milestone" \| "weekly_report" \| "mission_complete" \| "broadcast"` |
| `title` | `string` | Notification title |
| `body` | `string` | Notification body |
| `read` | `boolean` | Has user read it (default: `false`) |
| `data` | `map` | Extra payload (e.g., `{ missionId: "abc123" }`) |
| `createdAt` | `timestamp` | |

---

### Collection: `templates/{templateId}` (Admin-managed)

| Field | Type | Description |
|-------|------|-------------|
| `id` | `string` | Document ID |
| `name` | `string` | Template name (e.g., "Goa Trip") |
| `category` | `string` | Category key |
| `emoji` | `string` | Display emoji |
| `suggestedAmount` | `number` | Default target amount |
| `suggestedDuration` | `number` | Default duration in days |
| `isActive` | `boolean` | Shown to users |
| `createdAt` | `timestamp` | |

---

### Collection: `challenges/{challengeId}` (Admin-managed)

| Field | Type | Description |
|-------|------|-------------|
| `id` | `string` | Document ID |
| `title` | `string` | Challenge name |
| `description` | `string` | Challenge description |
| `startDate` | `timestamp` | |
| `endDate` | `timestamp` | |
| `targetDays` | `number` | Number of days to complete |
| `isActive` | `boolean` | Currently running |
| `participantCount` | `number` | Number of participants |
| `createdAt` | `timestamp` | |

---

### Collection: `featureFlags/{flagId}` (Admin-managed)

| Field | Type | Description |
|-------|------|-------------|
| `key` | `string` | Flag name (e.g., `"ai_nudges_enabled"`) |
| `enabled` | `boolean` | |
| `updatedAt` | `timestamp` | |
| `updatedBy` | `string` | Admin UID who last updated |

**MVP Feature Flags:**
- `ai_nudges_enabled`
- `streak_recovery_enabled`
- `challenges_enabled`
- `certificate_sharing_enabled`

---

### Collection: `aiLogs/{logId}` (For admin review)

| Field | Type | Description |
|-------|------|-------------|
| `userId` | `string` | |
| `missionId` | `string` | |
| `endpoint` | `string` | Which AI endpoint was called |
| `request` | `map` | Request payload |
| `response` | `map` | Response payload |
| `flagged` | `boolean` | Flagged for quality review |
| `createdAt` | `timestamp` | |

---

## 7. Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // ── Helper Functions ──

    function isAuthenticated() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return request.auth.uid == userId;
    }

    function isAdmin() {
      return isAuthenticated() &&
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }

    // ── Users ──

    match /users/{userId} {
      allow read: if isAuthenticated() && (isOwner(userId) || isAdmin());
      allow create: if isAuthenticated() && isOwner(userId);
      allow update: if isAuthenticated() && isOwner(userId) &&
        !request.resource.data.diff(resource.data).affectedKeys()
          .hasAny(['isAdmin', 'uid']);
      allow delete: if false;

      match /streakRecoveries/{recoveryId} {
        allow read, write: if isAuthenticated() && isOwner(userId);
      }
    }

    // ── Missions ──

    match /missions/{missionId} {
      allow read: if isAuthenticated() &&
        (resource.data.userId == request.auth.uid || isAdmin());
      allow create: if isAuthenticated() &&
        request.resource.data.userId == request.auth.uid &&
        request.resource.data.targetAmount >= 100 &&
        request.resource.data.durationDays >= 10 &&
        request.resource.data.durationDays <= 180;
      allow update: if isAuthenticated() &&
        (resource.data.userId == request.auth.uid || isAdmin());
      allow delete: if false;
    }

    // ── Contributions ──

    match /contributions/{contributionId} {
      allow read: if isAuthenticated() &&
        (resource.data.userId == request.auth.uid || isAdmin());
      allow create: if isAuthenticated() &&
        request.resource.data.userId == request.auth.uid &&
        request.resource.data.amount >= 10;
      allow update, delete: if false;  // immutable
    }

    // ── Badges ──

    match /badges/{badgeId} {
      allow read: if isAuthenticated() &&
        (resource.data.userId == request.auth.uid || isAdmin());
      allow create, update, delete: if false;  // Cloud Functions only
    }

    // ── Notifications ──

    match /notifications/{notificationId} {
      allow read: if isAuthenticated() &&
        resource.data.userId == request.auth.uid;
      allow update: if isAuthenticated() &&
        resource.data.userId == request.auth.uid &&
        request.resource.data.diff(resource.data).affectedKeys().hasOnly(['read']);
      allow create, delete: if false;  // Cloud Functions only
    }

    // ── Templates (public read, admin write) ──

    match /templates/{templateId} {
      allow read: if isAuthenticated();
      allow write: if isAdmin();
    }

    // ── Challenges ──

    match /challenges/{challengeId} {
      allow read: if isAuthenticated();
      allow write: if isAdmin();
    }

    // ── Feature Flags ──

    match /featureFlags/{flagId} {
      allow read: if isAuthenticated();
      allow write: if isAdmin();
    }

    // ── AI Logs (admin only) ──

    match /aiLogs/{logId} {
      allow read: if isAdmin();
      allow create: if false;  // Cloud Functions / FastAPI via Admin SDK
      allow update: if isAdmin();  // for flagging
      allow delete: if false;
    }
  }
}
```

---

## 8. Firestore Indexes

### Composite Indexes

| Collection | Fields | Query Purpose |
|-----------|--------|---------------|
| `missions` | `userId` ASC, `status` ASC, `createdAt` DESC | User's active missions sorted by creation |
| `missions` | `userId` ASC, `status` ASC | Count active missions (enforce max 3) |
| `missions` | `userId` ASC, `category` ASC, `createdAt` DESC | Filter missions by category |
| `missions` | `status` ASC, `endDate` ASC | Scheduled: find expired missions |
| `contributions` | `missionId` ASC, `date` DESC | Contribution history for a mission |
| `contributions` | `userId` ASC, `date` DESC | User's recent contributions |
| `contributions` | `userId` ASC, `missionId` ASC, `date` DESC | Check if contributed today for specific mission |
| `badges` | `userId` ASC, `earnedAt` DESC | User's badges sorted by recency |
| `badges` | `userId` ASC, `badgeType` ASC | Check if user already has a badge type |
| `notifications` | `userId` ASC, `read` ASC, `createdAt` DESC | Unread notifications |
| `notifications` | `userId` ASC, `createdAt` DESC | All notifications feed |
| `aiLogs` | `flagged` ASC, `createdAt` DESC | Admin: flagged AI outputs |
| `users` | `lastActiveAt` DESC | Admin: DAU queries |

---

## 9. Cloud Functions Spec

All functions use **Node.js 20** runtime, **TypeScript**, **Firebase Admin SDK v13+**.

### Scheduled Functions

| Function | Schedule (IST) | Description |
|----------|----------------|-------------|
| `evaluateDailyStreaks` | Every day 00:05 | Iterate all active missions. If `lastContributionDate` != yesterday, increment `missedDays`, reset `currentStreak` to 0 (unless recovery window applies). Recalculate `completionProbability`. |
| `sendDailyReminders` | Every day 09:00 | Query users with `notificationsEnabled == true`. Send personalized FCM per active mission. Respect user's `notificationTime`. |
| `sendStreakAlerts` | Every day 20:00 | Check active missions with no contribution logged today. Send warning FCM: "Your streak is at risk!" |
| `sendWeeklyReport` | Every Sunday 10:00 | Aggregate weekly stats per user. Send summary FCM + write notification doc. |
| `evaluateExpiredMissions` | Every day 00:30 | Mark missions past `endDate` with `savedAmount < targetAmount` as `"failed"`. |
| `triggerAiNudges` | Every day 12:00 | Find users who missed 2+ consecutive days OR have `completionProbability < 0.6`. Call FastAPI `/ai/nudge`. Send result as FCM. |

### Firestore Trigger Functions

| Function | Trigger | Description |
|----------|---------|-------------|
| `onMissionCreate` | `onCreate` on `missions/{missionId}` | Validate max 3 active missions. Set `completionProbability = 1.0`. Increment user's `totalMissionsCreated`. Create welcome notification. |
| `onContributionCreate` | `onCreate` on `contributions/{contributionId}` | Update parent mission: increment `savedAmount`, update `currentStreak`, set `lastContributionDate`. Check milestone thresholds (25/50/75/100%). Call `checkBadgeEligibility`. If 100% reached, set `status = "completed"`, set `completedAt`. |
| `onMissionComplete` | `onUpdate` on `missions/{missionId}` (status → `"completed"`) | Award `first_complete` badge (if first mission). Award `speed_runner` (if before deadline). Send celebration FCM. Increment user's `totalMissionsCompleted` and `totalSaved`. |

### Callable Functions

| Function | Access | Description |
|----------|--------|-------------|
| `recoverStreak` | User (own missions) | Validate: not used in last 7 days for this mission, mission is active, streak was broken yesterday. Restore `currentStreak`. Write `streakRecoveries` subcollection doc. |
| `getAdminAnalytics` | Admin only | Return aggregated stats: total users, DAU/WAU/MAU, completion rates by category, streak distribution, drop-off analysis. |
| `manageTemplate` | Admin only | CRUD on `templates` collection. |
| `manageChallenges` | Admin only | CRUD on `challenges` collection. |
| `manageFeatureFlags` | Admin only | Toggle flags in `featureFlags` collection. |
| `sendBroadcastNotification` | Admin only | Send FCM to all users or filtered segment. Write notification docs. |

---

## 10. FastAPI Endpoints

### `GET /health`
- **Auth:** None
- **Response:** `{ "status": "ok", "version": "1.0.0", "timestamp": "..." }`

---

### `POST /ai/nudge`
- **Auth:** Firebase ID token (Bearer)

**Request:**
```python
class NudgeRequest(BaseModel):
    user_id: str
    mission_id: str
    mission_title: str
    trigger: Literal["missed_day", "low_probability", "manual_request"]
    current_streak: int
    missed_days: int
    days_left: int
    amount_left: float
    target_amount: float
    completion_probability: float
```

**Response:**
```python
class NudgeResponse(BaseModel):
    message: str                    # LLM-generated nudge message
    action_suggestion: Literal[
        "extend_timeline",
        "reduce_daily",
        "split_mission",
        "motivational_only",
        "recovery_prompt"
    ] | None
    suggested_params: dict | None   # e.g. {"extra_days": 7} or {"new_daily": 150}
```

---

### `POST /ai/adapt`
- **Auth:** Firebase ID token

**Request:**
```python
class AdaptRequest(BaseModel):
    mission_id: str
    mission_title: str
    current_saved: float
    days_left: int
    target_amount: float
    daily_target: float
    current_streak: int
```

**Response:**
```python
class AdaptResponse(BaseModel):
    suggestion: Literal["reduce_daily", "extend_timeline", "split_mission", "on_track"]
    new_daily_amount: float | None
    new_end_date: str | None        # ISO 8601
    reasoning: str
```

---

### `POST /ai/predict`
- **Auth:** Firebase ID token

**Request:**
```python
class PredictRequest(BaseModel):
    mission_id: str
    streak_ratio: float             # current_streak / days_elapsed
    amount_ratio: float             # saved / target
    day_ratio: float                # days_elapsed / total_days
    missed_days: int
    total_days: int
```

**Response:**
```python
class PredictResponse(BaseModel):
    completion_probability: float   # 0.0 - 1.0
    risk_level: Literal["low", "medium", "high", "critical"]
    factors: list[str]              # e.g. ["high miss rate", "behind schedule"]
```

**Prediction Formula (MVP — Rule-Based):**
```python
score = (day_ratio * 0.5) + (amount_ratio * 0.4) + (streak_ratio * 0.1)

# Penalize for missed days
penalty = min(missed_days / total_days * 0.3, 0.3)
probability = max(0.0, min(1.0, score - penalty))
```

**Risk Level Thresholds:**
| Probability | Risk Level |
|-------------|-----------|
| >= 0.75 | `low` |
| >= 0.50 | `medium` |
| >= 0.25 | `high` |
| < 0.25 | `critical` |

---

### `POST /ai/message`
- **Auth:** Firebase ID token

**Request:**
```python
class MessageRequest(BaseModel):
    goal_name: str
    amount_left: float
    days_left: int
    streak: int
    category: str
    user_name: str | None = None
```

**Response:**
```python
class MessageResponse(BaseModel):
    message: str                    # LLM-generated motivational message
    tone: Literal["encouraging", "urgent", "celebratory", "gentle"]
```

**Example output:** *"You're ₹1,200 away from Goa. 6 days. Don't quit now — ₹200 is less than a Swiggy order."*

---

## 11. Authentication Flow

### Supported Methods
- Email/Password
- Google Sign-In
- Phone OTP

### Flow Diagram

```
App Launch
    │
    ▼
Check FirebaseAuth.instance.currentUser
    │
    ├── null ──────────────────> Show Onboarding → Login/Register Page
    │                                                    │
    │                                           Firebase Auth (email/google/otp)
    │                                                    │
    │                                                    ▼
    │                                           Check Firestore users/{uid}
    │                                                    │
    │                                              ┌─────┴─────┐
    │                                          Exists?      Not exists?
    │                                              │            │
    │                                          Navigate     Create user doc
    │                                          to Home      → Navigate to Home
    │
    └── exists ────────────────> Check users/{uid} doc
                                        │
                                   Navigate to Home
```

### Token Forwarding to FastAPI

```dart
// In api_client.dart interceptor
final idToken = await FirebaseAuth.instance.currentUser!.getIdToken();
options.headers['Authorization'] = 'Bearer $idToken';
```

```python
# In FastAPI auth middleware
from firebase_admin import auth
decoded_token = auth.verify_id_token(token)
user_id = decoded_token['uid']
```

### Admin Detection

- Check `users/{uid}.isAdmin == true` after login
- If `true`, show admin navigation item in bottom nav (or side drawer on web)
- Admin flag is **never** writable from client — set manually in Firebase Console

---

## 12. Notification System

### FCM Client Setup (Flutter)

1. Request notification permission on first launch (after onboarding)
2. Get FCM token via `FirebaseMessaging.instance.getToken()`
3. Store token in `users/{uid}.fcmToken`
4. Listen for token refresh → update Firestore
5. Handle foreground via `FirebaseMessaging.onMessage`
6. Handle background/terminated via `FirebaseMessaging.onBackgroundMessage`

### Notification Types

| Type | Trigger | Schedule | Example |
|------|---------|----------|---------|
| `daily_reminder` | Scheduled function | 9AM daily | "₹200 today = Goa is 1 day closer" |
| `streak_alert` | Scheduled function | 8PM if no contribution | "Your 7-day streak is at risk!" |
| `streak_break` | Daily streak evaluator | 00:05 (if missed) | "Streak lost. Recovery window: 24hrs." |
| `milestone` | On contribution (25/50/75%) | Realtime trigger | "Halfway there! You've saved ₹2,500!" |
| `weekly_report` | Scheduled function | Sunday 10AM | Summary: saved, streak, % complete |
| `mission_complete` | On mission 100% | Realtime trigger | Full celebration + certificate |
| `broadcast` | Admin callable | Manual | Admin-defined message |

### FCM Message Structure (Cloud Functions)

```typescript
{
  token: user.fcmToken,
  notification: {
    title: "Your streak is at risk!",
    body: "Log ₹200 before midnight to keep your 7-day streak alive."
  },
  data: {
    type: "streak_alert",
    missionId: "abc123",
    action: "log_contribution"
  },
  android: {
    priority: "high",
    notification: { channelId: "mission_invest_alerts" }
  },
  apns: {
    payload: { aps: { sound: "default", badge: 1 } }
  }
}
```

### Android Notification Channels

| Channel ID | Purpose | Importance |
|-----------|---------|------------|
| `mission_invest_reminders` | Daily reminders | Default |
| `mission_invest_alerts` | Streak alerts & breaks | High |
| `mission_invest_milestones` | Celebrations | High |
| `mission_invest_general` | Weekly reports, broadcasts | Default |

---

## 13. State Management (Riverpod)

### Core Providers

```dart
// Firebase Auth state stream
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Current user Firestore document
final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) => user != null
      ? ref.read(userRepositoryProvider).watchUser(user.uid)
      : Stream.value(null),
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});

// Theme
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

final selectedThemeNameProvider = StateProvider<String>((ref) => 'dark');
```

### Mission Providers

```dart
// Active missions (real-time stream)
final activeMissionsProvider = StreamProvider<List<MissionModel>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  return ref.read(missionRepositoryProvider).watchActiveMissions(user.uid);
});

// All missions (including completed/failed)
final allMissionsProvider = StreamProvider<List<MissionModel>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  return ref.read(missionRepositoryProvider).watchAllMissions(user.uid);
});

// Single mission detail
final missionDetailProvider = StreamProvider.family<MissionModel?, String>(
  (ref, missionId) {
    return ref.read(missionRepositoryProvider).watchMission(missionId);
  },
);

// Mission creation state
final missionCreateProvider = StateNotifierProvider<MissionCreateNotifier, AsyncValue<void>>(
  (ref) => MissionCreateNotifier(ref.read(missionRepositoryProvider)),
);

// Can create new mission (max 3 check)
final canCreateMissionProvider = Provider<bool>((ref) {
  final missions = ref.watch(activeMissionsProvider).value ?? [];
  return missions.length < 3;
});
```

### Contribution Providers

```dart
// Contributions for a specific mission
final missionContributionsProvider = StreamProvider.family<List<ContributionModel>, String>(
  (ref, missionId) {
    return ref.read(contributionRepositoryProvider).watchContributions(missionId);
  },
);

// Log contribution action
final logContributionProvider = StateNotifierProvider<LogContributionNotifier, AsyncValue<void>>(
  (ref) => LogContributionNotifier(
    ref.read(contributionRepositoryProvider),
    ref.read(missionRepositoryProvider),
  ),
);

// Today's contributions across all missions
final todayContributionsProvider = StreamProvider<List<ContributionModel>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  return ref.read(contributionRepositoryProvider).watchTodayContributions(user.uid);
});
```

### Badge Providers

```dart
// All badges for current user
final userBadgesProvider = StreamProvider<List<BadgeModel>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  return ref.read(badgeRepositoryProvider).watchUserBadges(user.uid);
});

// Badge count
final badgeCountProvider = Provider<int>((ref) {
  return ref.watch(userBadgesProvider).value?.length ?? 0;
});
```

### AI Providers

```dart
// AI nudge for a specific mission
final aiNudgeProvider = FutureProvider.family<NudgeResponse?, String>(
  (ref, missionId) async {
    final mission = ref.watch(missionDetailProvider(missionId)).value;
    if (mission == null) return null;
    return ref.read(aiRepositoryProvider).getNudge(mission);
  },
);

// Completion prediction
final aiPredictionProvider = FutureProvider.family<PredictResponse?, String>(
  (ref, missionId) async {
    final mission = ref.watch(missionDetailProvider(missionId)).value;
    if (mission == null) return null;
    return ref.read(aiRepositoryProvider).getPrediction(mission);
  },
);

// Motivational message
final aiMotivationProvider = FutureProvider.family<MessageResponse?, String>(
  (ref, missionId) async {
    final mission = ref.watch(missionDetailProvider(missionId)).value;
    if (mission == null) return null;
    return ref.read(aiRepositoryProvider).getMotivation(mission);
  },
);
```

### Notification Providers

```dart
// Notifications feed
final notificationsProvider = StreamProvider<List<NotificationModel>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  return ref.read(notificationRepositoryProvider).watchNotifications(user.uid);
});

// Unread count (for badge on nav)
final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsProvider).value ?? [];
  return notifications.where((n) => !n.read).length;
});
```

### Repository Providers (Dependency Injection)

```dart
final userRepositoryProvider = Provider<UserRepository>((ref) => UserRepository());
final missionRepositoryProvider = Provider<MissionRepository>((ref) => MissionRepository());
final contributionRepositoryProvider = Provider<ContributionRepository>((ref) => ContributionRepository());
final badgeRepositoryProvider = Provider<BadgeRepository>((ref) => BadgeRepository());
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) => NotificationRepository());
final aiRepositoryProvider = Provider<AiRepository>((ref) => AiRepository(ref.read(apiClientProvider)));
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());
final adminRepositoryProvider = Provider<AdminRepository>((ref) => AdminRepository());
```

### Admin Providers

```dart
final adminAnalyticsProvider = FutureProvider<AdminAnalytics>((ref) async {
  return ref.read(adminRepositoryProvider).getAnalytics();
});

final adminUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  return ref.read(adminRepositoryProvider).getUsers();
});

final featureFlagsProvider = StreamProvider<List<FeatureFlag>>((ref) {
  return ref.read(adminRepositoryProvider).watchFeatureFlags();
});

final templatesProvider = StreamProvider<List<TemplateModel>>((ref) {
  return ref.read(adminRepositoryProvider).watchTemplates();
});
```

---

## 14. Routing Map (GoRouter)

### Route Configuration

```dart
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      final isOnboarding = state.matchedLocation == '/onboarding';

      if (!isLoggedIn && !isAuthRoute && !isOnboarding) return '/auth/login';
      if (isLoggedIn && isAuthRoute) return '/';
      return null;
    },
    routes: [/* see below */],
  );
});
```

### All Routes (24 screens)

| Path | Name | Page | Shell? |
|------|------|------|--------|
| `/onboarding` | `onboarding` | OnboardingPage | No |
| `/auth/login` | `login` | LoginPage | No |
| `/auth/register` | `register` | RegisterPage | No |
| `/auth/forgot-password` | `forgotPassword` | ForgotPasswordPage | No |
| `/auth/otp` | `otpVerification` | OtpVerificationPage | No |
| `/` | `home` | HomePage | Yes (Bottom Nav) |
| `/missions` | `missionList` | MissionListPage | Yes (Bottom Nav) |
| `/rewards` | `rewards` | BadgesPage | Yes (Bottom Nav) |
| `/profile` | `profile` | ProfilePage | Yes (Bottom Nav) |
| `/missions/create` | `missionCreate` | MissionCreatePage | No (full screen) |
| `/missions/:missionId` | `missionDetail` | MissionDetailPage | No |
| `/missions/:missionId/edit` | `missionEdit` | MissionEditPage | No |
| `/missions/:missionId/contribute` | `logContribution` | LogContributionPage | No |
| `/missions/:missionId/history` | `contributionHistory` | ContributionHistoryPage | No |
| `/missions/:missionId/certificate` | `certificate` | CertificatePage | No |
| `/settings` | `settings` | SettingsPage | No |
| `/notifications` | `notificationSettings` | NotificationSettingsPage | No |
| `/admin` | `adminDashboard` | AdminDashboardPage | No |
| `/admin/users` | `adminUsers` | AdminUsersPage | No |
| `/admin/analytics` | `adminAnalytics` | AdminAnalyticsPage | No |
| `/admin/templates` | `adminTemplates` | AdminTemplatesPage | No |
| `/admin/challenges` | `adminChallenges` | AdminChallengesPage | No |
| `/admin/notifications` | `adminNotifications` | AdminNotificationsPage | No |
| `/admin/feature-flags` | `adminFeatureFlags` | AdminFeatureFlagsPage | No |
| `/admin/ai-review` | `adminAiReview` | AdminAiReviewPage | No |

### Bottom Navigation Tabs

| Index | Label | Icon | Route |
|-------|-------|------|-------|
| 0 | Home | `Icons.home` | `/` |
| 1 | Missions | `Icons.flag` | `/missions` |
| 2 | Rewards | `Icons.emoji_events` | `/rewards` |
| 3 | Profile | `Icons.person` | `/profile` |

---

## 15. Dependencies

### 15a. Flutter (`pubspec.yaml`)

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

  # State Management
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1

  # Routing
  go_router: ^14.8.1

  # Firebase
  firebase_core: ^3.12.1
  firebase_auth: ^5.5.1
  cloud_firestore: ^5.6.5
  firebase_storage: ^12.4.4
  firebase_messaging: ^15.2.4
  firebase_analytics: ^11.4.4

  # Networking (for FastAPI calls)
  dio: ^5.7.0

  # UI Components
  flutter_animate: ^4.5.2
  lottie: ^3.3.1
  percent_indicator: ^4.2.5          # progress ring
  fl_chart: ^0.70.2                  # charts (admin analytics)
  cached_network_image: ^3.4.1
  shimmer: ^3.0.0                    # loading skeletons
  flutter_svg: ^2.0.16

  # Forms
  reactive_forms: ^17.1.1

  # Image
  image_picker: ^1.1.2

  # Sharing
  share_plus: ^10.1.4
  screenshot: ^3.0.0                 # certificate capture

  # Local Storage
  shared_preferences: ^2.5.2

  # Utility
  intl: ^0.20.1                      # date/currency formatting
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
  uuid: ^4.5.1
  url_launcher: ^6.3.1
  package_info_plus: ^8.2.1
  connectivity_plus: ^6.1.1

  # Google Sign-In
  google_sign_in: ^6.2.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  build_runner: ^2.4.13
  freezed: ^2.5.7
  json_serializable: ^6.9.0
  riverpod_generator: ^2.6.3
  mockito: ^5.4.4
  mocktail: ^1.0.4
```

### 15b. Firebase Cloud Functions (`functions/package.json`)

```json
{
  "name": "mission-invest-functions",
  "main": "lib/index.js",
  "scripts": {
    "build": "tsc",
    "serve": "npm run build && firebase emulators:start --only functions",
    "deploy": "firebase deploy --only functions"
  },
  "engines": { "node": "20" },
  "dependencies": {
    "firebase-admin": "^13.0.2",
    "firebase-functions": "^6.3.0",
    "axios": "^1.7.9",
    "date-fns": "^4.1.0",
    "date-fns-tz": "^3.2.0",
    "zod": "^3.24.1"
  },
  "devDependencies": {
    "typescript": "^5.7.3",
    "firebase-functions-test": "^3.4.0",
    "@types/node": "^20.17.12"
  }
}
```

### 15c. FastAPI (`requirements.txt`)

```
fastapi==0.115.6
uvicorn[standard]==0.34.0
pydantic==2.10.5
pydantic-settings==2.7.1
firebase-admin==6.6.0
httpx==0.28.1
langchain==0.3.15
langchain-anthropic==0.3.5
langchain-openai==0.3.2
python-dotenv==1.0.1
structlog==24.4.0
gunicorn==23.0.0
```

---

## 16. Environment & Config

### Flutter (`lib/core/constants/api_endpoints.dart`)

```dart
class ApiEndpoints {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );

  static const String nudge = '/ai/nudge';
  static const String adapt = '/ai/adapt';
  static const String predict = '/ai/predict';
  static const String message = '/ai/message';
  static const String health = '/health';
}
```

Firebase config is auto-generated via `flutterfire configure`.

### Cloud Functions (`.env` or Firebase environment config)

```env
FASTAPI_BASE_URL=https://mission-invest-ai-xxxxx.run.app
FASTAPI_API_KEY=<shared-secret-for-functions-to-fastapi>
```

### FastAPI (`.env`)

```env
FIREBASE_PROJECT_ID=mission-invest-prod
FIREBASE_CREDENTIALS_PATH=./service-account.json
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...
LLM_PROVIDER=anthropic
LLM_MODEL=claude-sonnet-4-20250514
CORS_ORIGINS=["http://localhost:3000","https://mission-invest.web.app"]
LOG_LEVEL=info
PORT=8000
```

### Environment Matrix

| Variable | Dev | Staging | Prod |
|----------|-----|---------|------|
| Firebase project | `mission-invest-dev` | `mission-invest-staging` | `mission-invest-prod` |
| FastAPI URL | `http://localhost:8000` | Cloud Run staging | Cloud Run prod |
| LLM model | `claude-sonnet-4-20250514` | same | same |
| Log level | `debug` | `info` | `warning` |

---

## 17. Error Handling Strategy

### Flutter App

| Layer | Strategy |
|-------|----------|
| **Repository** | All Firestore/HTTP calls wrapped in try-catch. Throw typed exceptions: `NetworkException`, `AuthException`, `FirestoreException`, `ApiException`. |
| **Provider** | Use `AsyncValue` (built into Riverpod). Expose `.loading`, `.data`, `.error` states. |
| **UI** | Every async widget uses `.when(data: ..., loading: ..., error: ...)`. Show `AppErrorWidget` with retry on errors. Show shimmer on loading. |
| **Global** | `FlutterError.onError` and `PlatformDispatcher.instance.onError` catch unhandled errors. |
| **Offline** | `connectivity_plus` checks network. Firestore offline persistence enabled by default. Show offline banner when disconnected. Queue FastAPI calls for retry. |

### Cloud Functions (TypeScript)

| Aspect | Strategy |
|--------|----------|
| **Try-catch** | All functions wrapped with structured logging via `functions.logger` |
| **Atomicity** | Firestore writes use transactions where needed (e.g., contribution + mission update) |
| **Callable response** | `{ success: boolean, data?: any, error?: { code: string, message: string } }` |
| **Idempotency** | Scheduled functions check if action was already taken today before proceeding |

### FastAPI (Python)

| Aspect | Strategy |
|--------|----------|
| **Response format** | Consistent `{ detail: str, error_code: str }` on all errors |
| **Validation** | HTTP 400 — Pydantic handles automatically |
| **Auth** | HTTP 401 — invalid/expired Firebase token |
| **Rate limiting** | HTTP 429 — 10 requests/minute per user for AI endpoints |
| **Server error** | HTTP 500 — logged with full trace |
| **LLM fallback** | If LLM call fails, return template-based message with variable substitution |

---

## 18. MVP Scope & Phases

### Phase 1: Foundation (Days 1–5)

| Dev | Tasks |
|-----|-------|
| **Dev 1 (Flutter)** | Project setup (Riverpod, GoRouter, Firebase init), auth screens (login, register, forgot password), theme system (4 themes), bottom nav shell, home page skeleton |
| **Dev 2 (Firebase)** | Firebase project creation, Firestore rules v1, indexes, Cloud Functions scaffold, `onMissionCreate` trigger |
| **Dev 3 (FastAPI)** | Project scaffold, health endpoint, auth middleware, `/ai/predict` with rule-based formula |

### Phase 2: Core Mission Flow (Days 6–10)

| Dev | Tasks |
|-----|-------|
| **Dev 1 (Flutter)** | Mission create page (form, category picker, vision image upload), mission list page, mission detail page (progress ring, streak counter, milestones), log contribution page |
| **Dev 2 (Firebase)** | `onContributionCreate` (update savedAmount, streak), `evaluateDailyStreaks` scheduled function, `evaluateExpiredMissions` |
| **Dev 3 (FastAPI)** | `/ai/nudge` endpoint, `/ai/message` with LLM integration, `/ai/adapt` endpoint |

### Phase 3: Engagement Layer (Days 11–15)

| Dev | Tasks |
|-----|-------|
| **Dev 1 (Flutter)** | Badges page, certificate page (screenshot + share), notification UI, streak recovery UI, profile/settings page |
| **Dev 2 (Firebase)** | Badge award logic (`checkBadgeEligibility`), all notification functions (daily reminder, streak alert, weekly report, milestone, completion), `recoverStreak` callable |
| **Dev 3 (FastAPI)** | Prompt engineering refinement, fallback templates, rate limiting, AI logging to Firestore (`aiLogs`) |

### Phase 4: Admin & Polish (Days 16–20)

| Dev | Tasks |
|-----|-------|
| **Dev 1 (Flutter)** | Admin dashboard (Flutter Web), analytics charts, user table, template CRUD, challenge management, feature flag toggles, AI log review, broadcast notification UI |
| **Dev 2 (Firebase)** | `getAdminAnalytics` callable, `manageTemplate` callable, `sendBroadcastNotification` callable, `manageFeatureFlags` callable, `manageChallenges` callable |
| **Dev 3 (FastAPI)** | Dockerize, deploy to Cloud Run, load testing, API documentation |

### Phase 5: QA & Launch (Days 21–25)

- Integration testing across all three repos
- Edge case handling (timezone, max missions, streak boundary conditions)
- Performance optimization (Firestore query optimization, provider disposal)
- App icon, splash screen, onboarding illustrations
- Play Store / App Store listing prep

### Post-MVP (v2 Roadmap)

- Full ML completion probability model (trained on user cohort data)
- UPI/bank auto-save integration
- Social leaderboards & friend challenges
- Platform-wide challenges with leaderboard
- Firebase Crashlytics integration
- A/B testing framework

---

## 19. Admin Dashboard

Built as part of the same Flutter app codebase. Conditionally shown when `users/{uid}.isAdmin == true`. Deployed to Firebase Hosting as a separate `flutter build web` target.

### Admin Screens

#### 1. Dashboard (`/admin`)
- KPI cards: Total users, DAU, WAU, MAU
- Quick stats: active missions, contributions today, average streak length
- Total missions created, completion rate
- Recent activity feed

#### 2. User Management (`/admin/users`)
- Paginated user table: name, email, join date, active missions, global streak, last active
- Search by name/email
- Click to view user detail (all their missions, badges, contributions)
- Read-only (no edit/delete — privacy)

#### 3. Analytics (`/admin/analytics`)
- Line chart: DAU/WAU/MAU over time
- Bar chart: missions by category
- Pie chart: mission status distribution (active/completed/failed/paused)
- Funnel: Day 1 → Day 3 → Day 7 → Day 30 retention
- Histogram: streak length distribution
- Table: drop-off analysis (which day users abandon most)
- Average days to first failure

#### 4. Templates (`/admin/templates`)
- CRUD table: name, category, emoji, suggested amount, suggested duration, active toggle
- Create/edit form in dialog modal

#### 5. Challenges (`/admin/challenges`)
- List of platform-wide challenges
- Create form: title, description, start/end date, target days
- Toggle active/inactive
- View participant count

#### 6. Broadcast Notifications (`/admin/notifications`)
- Compose form: title, body, target segment (all users, active users, inactive 7d+)
- Send history log with timestamp and recipient count
- Preview before send

#### 7. Feature Flags (`/admin/feature-flags`)
- Toggle table: flag key, current state, last updated, updated by
- Simple on/off switch per flag

#### 8. AI Review (`/admin/ai-review`)
- Table of AI-generated messages from `aiLogs` collection
- Filter: flagged only, by endpoint, by date range
- Flag/unflag button per entry
- Expandable row to view full request/response payload

---

## 20. Naming Conventions & Coding Standards

### Dart (Flutter)

| Element | Convention | Example |
|---------|-----------|---------|
| Files | `snake_case.dart` | `mission_model.dart`, `home_page.dart` |
| Classes | `PascalCase` | `MissionModel`, `HomePage` |
| Variables & functions | `camelCase` | `savedAmount`, `watchActiveMissions()` |
| Constants | `camelCase` | `maxActiveMissions = 3` |
| Providers | `camelCase` + `Provider` suffix | `activeMissionsProvider` |
| Pages | `PascalCase` + `Page` suffix | `MissionCreatePage` |
| Widgets | `PascalCase` (descriptive) | `ProgressRing`, `MissionCard` |
| Models | `PascalCase` + `Model` suffix | `MissionModel`, `BadgeModel` |
| Repositories | `PascalCase` + `Repository` suffix | `MissionRepository` |
| Notifiers | `PascalCase` + `Notifier` suffix | `MissionCreateNotifier` |
| Enums | `PascalCase` name, `camelCase` values | `MissionStatus.active` |
| Private members | `_` prefix | `_HomePageState` |
| Max line length | 80 characters | — |
| Trailing commas | Always on multi-line | For consistent formatting |

### TypeScript (Cloud Functions)

| Element | Convention | Example |
|---------|-----------|---------|
| Files | `camelCase.ts` | `evaluateStreaks.ts` |
| Functions | `camelCase` | `evaluateDailyStreaks` |
| Interfaces | `PascalCase` (no `I` prefix) | `MissionData` |
| Constants (env) | `UPPER_SNAKE_CASE` | `FASTAPI_BASE_URL` |
| Constants (code) | `camelCase` | `maxActiveMissions` |
| Types | Strict TypeScript, no `any` | Use Zod for runtime validation |

### Python (FastAPI)

| Element | Convention | Example |
|---------|-----------|---------|
| Files | `snake_case.py` | `nudge_service.py` |
| Classes | `PascalCase` | `NudgeRequest`, `PredictionService` |
| Functions & variables | `snake_case` | `get_nudge`, `completion_probability` |
| Constants | `UPPER_SNAKE_CASE` | `MAX_REQUESTS_PER_MINUTE` |
| Pydantic models | `PascalCase` + `Request`/`Response` | `NudgeRequest`, `NudgeResponse` |
| Router prefixes | `/ai/` | All AI endpoints |
| Type hints | Mandatory on all functions | — |
| Docstrings | Google style | On all public functions |

### General Standards

| Rule | Detail |
|------|--------|
| **Firestore paths** | Never hardcode — use `CollectionPaths.missions` constants |
| **No magic numbers** | All constants in `app_constants.dart` / `config.ts` / `config.py` |
| **Imports** | Relative within feature, package import across features |
| **Git branches** | `feature/mi-<ticket>-short-description` |
| **Commits** | `feat(scope): description` — conventional commits |
| **PR titles** | Match commit convention, under 70 chars |

---

*TDD Version: 1.0 | Status: Final | Last Updated: April 2026*

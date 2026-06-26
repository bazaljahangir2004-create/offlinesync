# OfflineSync — Offline-First Field Inspection App

A Flutter mobile app for capturing site inspection reports — photos, notes, and GPS location — that works completely offline and automatically syncs to the cloud the moment connectivity returns.

Built to solve a real problem field workers face: spotty or no internet access on-site (warehouses, construction sites, rural locations), with no tolerance for losing data because "the app needed WiFi."

## Demo

> 📹 [Add your demo video link here once recorded]

![App screenshot placeholder](docs/screenshot.png)

## The Problem This Solves

Most CRUD-style mobile apps assume a live internet connection. In real field conditions — basements, warehouses, rural sites — that assumption breaks, and a typical app either crashes, loses data, or simply can't be used. OfflineSync is built offline-first from the ground up: every report is captured and stored locally first, with cloud sync treated as a background concern, not a blocker.

## Key Features

- **Fully offline report creation** — title, notes, up to 3 photos, and GPS location, all captured and saved with zero network dependency
- **Automatic background sync** — the moment the device regains connectivity, all pending reports upload automatically (photos to Cloudinary, structured data to Firestore)
- **Visual sync status** — every report shows a live status badge (Draft / Syncing / Synced / Failed), so the user always knows what's been backed up
- **Failure recovery** — if a sync fails (bad connection mid-upload, server error), the report is marked Failed with the actual error message, and can be retried with one tap — no data is ever silently lost
- **Secure by design** — Firebase Authentication gates all access; Firestore security rules validate every field server-side (length limits, required fields, type checks) so the client can never write malformed data even if compromised
- **Manual sync override** — a sync-now button for users who want to force a sync rather than wait for the automatic listener

## Architecture

```
UI Layer (Flutter widgets)
    ↓ watches
Riverpod Providers (reactive state)
    ↓ reads/writes
┌─────────────────┬──────────────────┐
│  Local Layer     │   Cloud Layer    │
│  Drift (SQLite)  │   Firestore      │
│                  │   Cloudinary     │
└─────────────────┴──────────────────┘
```

**Why this shape:**

- **Drift (SQLite)** is the source of truth on-device. The UI always reads from here — never directly from the network — so the app behaves identically whether online or offline.
- **A locally-generated UUID** is created the moment a report is saved, and reused as the Firestore document ID later. This means sync is naturally idempotent: retrying a sync after a partial failure overwrites the same document rather than creating duplicates.
- **Riverpod's `StreamProvider`** watches the local database directly, so the UI updates in real time the instant a report's sync status changes — no manual refresh logic anywhere in the app.
- **Cloudinary handles media, Firestore handles structured data** — a deliberate cost/architecture decision (see below) rather than defaulting to a single all-in-one backend.

## Tech Stack

| Layer | Choice | Why |
|---|---|---|
| Framework | Flutter / Dart | Cross-platform mobile, single codebase |
| State management | Riverpod | Testable, reactive, scales cleanly as the app grows |
| Local database | Drift (SQLite) | Type-safe queries, reactive streams, offline-first by design |
| Auth | Firebase Authentication | Email/password sign-in, gates all cloud access |
| Cloud database | Cloud Firestore | Real-time structured data store for report metadata |
| Media storage | Cloudinary | See note below |
| Location | Geolocator | GPS capture with graceful permission handling |
| Connectivity | connectivity_plus | Detects online/offline transitions to trigger auto-sync |

### A real engineering decision, not a default

Firebase Cloud Storage now requires a billing-enabled (Blaze) plan even to initialize — there's no free tier for file storage anymore. Rather than introduce a billing dependency for a project with no revenue, **Cloudinary** was used instead for media storage, with Firestore handling only structured data. This is a genuine cost/architecture trade-off made deliberately, not a workaround — and it kept the project fully free-tier compatible end to end.

## Security

- All reads/writes require Firebase Authentication — no anonymous access
- Firestore rules validate every field server-side: required fields, string length caps, list size limits, type checks — so the client can never push malformed or oversized data even if the app itself were compromised
- Cloudinary upload preset is unsigned (no API secret ever ships in the app) but scoped: restricted file types, size caps, and a dedicated folder
- No deletes are permitted from the client — only create/update

## What I'd Build Next

- Multi-form support (currently scoped to one report type by design, to ship a complete, polished flow rather than a half-built generic form builder)
- Conflict resolution UI for the rare case of the same report being edited on two devices before either syncs
- Push notifications when a teammate's report syncs (would require a small Cloud Functions trigger)

## Getting Started

```bash
git clone <your-repo-url>
cd offlinesync
flutter pub get
```

You'll need your own Firebase project (Authentication + Firestore enabled) and a Cloudinary account with an unsigned upload preset. See `lib/firebase_options.example.dart` for the expected config shape, and set your own values in `lib/providers/sync_provider.dart`.

```bash
flutter run
```

## About This Project

Built as a portfolio project to demonstrate production-grade mobile engineering patterns: offline-first architecture, reactive state management, cloud sync with failure recovery, and security-conscious backend design — rather than a basic CRUD demo.

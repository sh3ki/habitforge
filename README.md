# HabitForge

> A habit tracking app that builds the systems to make good habits stick for good.

---

## Overview

HabitForge helps users design, track, and sustain daily habits across any life area — health, mindfulness, productivity, or learning. Habits are grouped into routines, tracked with a streak system, and visualized with heatmaps and completion trends to keep users accountable.

---

## Problem

Many people start habits but give up within weeks because motivation fades and there is no feedback loop rewarding consistency. Existing apps focus on simple checkboxes without surfacing patterns or helping users understand what's working.

---

## Solution

HabitForge makes streaks and patterns visible through heatmaps and weekly analytics. Users build routines from groups of habits, get smart reminders, and receive streak-protection nudges before they miss a day. The system rewards consistency rather than perfection.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| Auth | Supabase Auth (email + Apple OAuth) |
| Database | Supabase PostgreSQL |
| Real-time | Supabase Realtime |
| Edge Logic | Supabase Edge Functions (Deno) |
| Notifications | flutter_local_notifications + timezone |
| Charts | fl_chart + table_calendar |
| Progress UI | percent_indicator |
| State | Riverpod |
| Offline Cache | Hive |

---

## Features

**Core**
- Create habits with name, icon, color, category, frequency (daily, weekdays, custom days), and target count
- Organize habits into named routines (morning, evening, workout)
- One-tap habit check-in with haptic confirmation
- Streak counter: current streak, longest streak, total completions
- GitHub-style 12-month heatmap per habit
- Weekly summary card: completion rate, missed days, best day

**Backend & Infrastructure**
- Supabase Auth with email/password and Apple Sign-In; user session persisted locally
- `habits`, `routines`, `completions` tables in Supabase PostgreSQL with Row Level Security — all queries scoped to `auth.uid()`
- Supabase Realtime subscription on `completions` — syncs completions live across two devices logged in to the same account
- Supabase Edge Function `streak-calculator`: runs on INSERT to `completions` table, recalculates streak and updates `habits.current_streak` atomically
- Supabase Edge Function `daily-digest`: scheduled cron at 8 PM — queries incomplete habits for the day and delivers a reminder payload to the notification service
- Hive local cache for offline check-in; pending completions queue is flushed and upserted to Supabase on reconnect
- PostgreSQL RLS policies block cross-user data access at the database level

**Notifications & Gamification**
- Per-habit configurable reminder times, stored as cron expressions and evaluated by the Edge Function
- Streak milestone celebrations (7, 30, 100 days) with confetti animation
- Streak protection: push notification 2 hours before midnight if habit is still incomplete
- Gentle failure reframing — app presents missed days as "rest days" and recalculates based on user-set intent

**UX**
- Drag-to-reorder habits within a routine
- Calendar view with completion dots per day
- Dark / light theme with system auto-switch

---

## Challenges

- Accurately computing streaks server-side when the user is in different time zones across sessions
- Preventing duplicate completions if the offline queue flushes twice on an unstable connection
- Keeping Hive and Supabase in sync when the user modifies a habit definition (not just a completion)

---

## Screenshots

_Dashboard · Habit Detail · Heatmap · Routines_

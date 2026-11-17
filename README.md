
<div align="center">

# Learning Journey 🔥

![Learning Journey](./Learning%20Journey%20App%20Hero.png)

**Build consistency. Track progress. Keep learning.**

A native iOS application built with **SwiftUI** to help learners develop daily learning habits, maintain streaks, and achieve personalized learning goals.

![iOS](https://img.shields.io/badge/Platform-iOS-000000?style=flat-square&logo=apple)
![Swift](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-007AFF?style=flat-square&logo=swift&logoColor=white)
![MVVM](https://img.shields.io/badge/Architecture-MVVM-8B5CF6?style=flat-square)
![Status](https://img.shields.io/badge/Status-In%20Development-E68D40?style=flat-square)

</div>

---

## Overview

Learning Journey makes building a learning habit simple and measurable.

Users set a learning goal, record daily progress, and track their consistency through learning streaks and an interactive activity calendar.

## Features

- **Learning Goals** — Create and update goals for a Week, Month, or Year.
- **Log as Learned** — Record daily learning with a single tap; tap again to undo.
- **Freeze for a Day** — Preserve streak continuity during breaks without increasing the streak.
- **Learning Streak** — Track consecutive learning progress with an automatic reset after 32 hours of inactivity.
- **Activity Calendar** — View learning history through weekly and scrollable calendar views.
- **Activity Dashboard** — Monitor the current streak and used freeze days.
- **Goal Completion** — Display success or expiration states and allow users to set a new goal.
- **Local Persistence** — Preserve goals, activity history, and streak information using `UserDefaults`.

### Freeze Allowance

| Week | Month | Year |
|:---:|:---:|:---:|
| 2 freezes | 8 freezes | 96 freezes |

## Architecture

Built using **MVVM (Model–View–ViewModel)** with Swift's Observation framework.

```text
Learning_ch2/
├── Model/
│   ├── Model.swift
│   └── LearningHistoryStore.swift
├── View/
│   ├── onboardingView.swift
│   ├── CurrentDayView.swift
│   ├── LearningGoalView.swift
│   └── BeginningView.swift
├── ViewModels/
│   ├── AppViewModel.swift
│   ├── CurrentDayViewModel.swift
│   └── LearningGoalViewModel.swift
└── MyApp.swift
```

**Model** manages learning data and activity history. **ViewModel** handles goal management, streak calculations, and state updates. **View** presents the interface using SwiftUI.

## Tech Stack

| Technology | Purpose |
|---|---|
| Swift & SwiftUI | Native iOS development |
| Observation | Reactive state management |
| HorizonCalendar | Scrollable activity calendar |
| UserDefaults | Local data persistence |
| SF Symbols | Native iconography |
| Liquid Glass | Interface styling |
| Xcode | Development and testing |

## Getting Started

1. Clone the repository.
2. Open `Learning_ch2.xcodeproj` in Xcode.
3. Resolve the **HorizonCalendar** Swift Package dependency.
4. Select a compatible iOS Simulator or device.
5. Build and run the application (`⌘ + R`).

## Future Improvements

- Push notifications and learning reminders.
- Detailed learning analytics.
- Achievement milestones.
- Automated unit testing.

## Acknowledgments

Developed using Apple's **SwiftUI** framework and Airbnb's [HorizonCalendar](https://github.com/airbnb/HorizonCalendar).

---

<div align="center">

**One day at a time. One goal at a time. 🔥**

</div>

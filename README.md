# 🐵✨ MonKi — Gamified Spending Reflection App

MonKi empowers children to build healthy spending habits through interactive, story-based gamification that encourages reflective decision-making. Kids learn to spend wisely through fun narrative experiences, while parents stay engaged by reviewing and discussing their child’s choices within the app.

---

## 📌 Table of Contents

- [About the Project](#about-the-project)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Architecture Overview](#architecture-overview)
- [Screenshots](#screenshots)
- [Getting Started](#getting-started)

  - [Screenshots](#screenshots)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
    - [Usage](#usage)
  - [Project Structure](#project-structure)
  - [Boilerplate Swift Project (example)](#boilerplate-swift-project-example)
  - [Roadmap](#roadmap)
  - [Contributing](#contributing)
  - [License](#license)
  - [Contact](#contact)
  - [Acknowledgements](#acknowledgements)

  ***

  ## About the Project

  Children often form spending habits early. MoneyMon helps caregivers and kids build reflective financial habits through an interactive, narrative-driven experience.

  Key goals:

  - Encourage children to reflect after spending
  - Provide parents with insights and discussion prompts
  - Use rewards and gentle gamification to sustain engagement

  ***

  ## Features

  - Child-friendly UI for logging expenses
  - Emotion-based tagging for purchases (e.g., Happy, Useful)
  - Gamification & rewards system
  - Parent monitoring and review view
  - Simple analytics and spending trends
  - Local data persistence (Core Data)

  ***

  ## Tech Stack

  | Category   | Technology                |
  | ---------- | ------------------------- |
  | Platform   | iOS 17+                   |
  | Language   | Swift 5.9                 |
  | Frameworks | SwiftUI, UIKit, Core Data |
  | Tools      | Xcode 15+                 |

  ***

  ## Architecture Overview

  - MVVM (Model-View-ViewModel) structure
  - Small, testable components
  - Core Data for local persistence

  ***

  ## Screenshots

  _(Add screenshots in `images/` and update the paths below)_

  | Home                     | Reflection                           | Insights                         |
  | ------------------------ | ------------------------------------ | -------------------------------- |
  | ![home](images/home.png) | ![reflection](images/reflection.png) | ![insights](images/insights.png) |

  ***

  ## Getting Started

  ### Prerequisites

  - Xcode 15 or later
  - macOS with development tools installed

  ### Installation

  Clone the repo and open the project in Xcode:

  ```sh
  git clone https://github.com/yinsxie/MonKi.git
  cd MonKi
  open MonKi.xcodeproj
  ```

  ### Usage

  1. Open `MonKi.xcodeproj` in Xcode.
  2. Select a simulator (iOS 17+) or a connected device.
  3. Build and run (Cmd+R).

  If you plan to run tests, use the Test navigator or press Cmd+U.

  ***

  ## Project Structure

  This project contains a standard SwiftUI app structure. The key files and folders are listed below:

  ```
  MonKi/
  ├─ MonKiApp.swift            # App entry point (SwiftUI @main)
  ├─ ContentView.swift         # Root view for the app
  ├─ Assets.xcassets/          # App icons and colors
  ├─ MonKi.xcdatamodeld/       # Core Data model
  ├─ MonKi.xcodeproj/          # Xcode project
  ├─ MonKiTests/               # Unit tests
  └─ MonKiUITests/             # UI tests
  ```

  Notes:

  - Keep views small and stateless where possible; put business logic in view models.
  - Core Data models live in `MonKi.xcdatamodeld`.

  ***

  ## Boilerplate Swift Project (example)

  If you want a quick example of how to structure features, consider grouping by feature modules:

  ```
  MonKi/
  ├─ App/                     # App entry & app-wide setup
  │  └─ MonKiApp.swift
  ├─ Features/
  │  ├─ Dashboard/
  │  │  ├─ DashboardView.swift
  │  │  └─ DashboardViewModel.swift
  │  ├─ Reflection/
  │  │  ├─ ReflectionView.swift
  │  │  └─ ReflectionViewModel.swift
  │  └─ Shared/               # Shared helpers, extensions
  ├─ Models/                  # Data models and Core Data helpers
  ├─ Resources/               # Images, local JSON fixtures
  └─ Tests/
  ```

  This grouping keeps related files together and scales well as features are added.

  ***

  ## Roadmap

  - Add more analytics and charts
  - Add parental review workflows and notifications
  - Improve onboarding and tutorial content

  ***

  ## Contributing

  Contributions are welcome. Please open issues for bugs or feature requests, and create pull requests for proposed changes.

  Guidelines:

  - Keep changes small and focused
  - Add unit tests for logic where practical
  - Follow SwiftLint / project style where applicable

  ***

  ## License

  This project is provided under the MIT License. See `LICENSE` for details (add a LICENSE file if missing).

  ***

  ## Contact

  Project maintained by yinsxie — open an issue or reach out via GitHub.

  ***

  ## Acknowledgements

  - Apple Human Interface Guidelines
  - Teaching resources and tutorials used while developing this project

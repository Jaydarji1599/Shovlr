# Shovlr iOS App - Project Structure

## Overview
This document describes the structure and organization of the Shovlr iOS application codebase.

## Directory Structure

```
ShovlrApp/
├── ShovlrApp.swift              # Main app entry point
├── ContentView.swift            # Main tab navigation
├── Info.plist                   # App configuration
│
├── Models/                      # Data models
│   ├── Address.swift           # Address model
│   ├── Job.swift               # Job/Order model with status enum
│   ├── JobType.swift           # Job type and snow depth enums
│   ├── Payment.swift           # Payment models
│   └── User.swift              # User model
│
├── ViewModels/                  # State management
│   ├── AuthViewModel.swift     # Authentication state
│   ├── OrderViewModel.swift    # Order creation and tracking
│   ├── HistoryViewModel.swift  # Job history
│   └── ProfileViewModel.swift  # User profile management
│
├── Views/                       # UI Components
│   ├── Components/             # Reusable UI components
│   │   ├── PrimaryButton.swift
│   │   ├── CustomTextField.swift
│   │   ├── StatusBadge.swift
│   │   ├── JobTypeSelector.swift
│   │   ├── PriceDisplay.swift
│   │   └── LoadingView.swift
│   │
│   ├── Onboarding/             # Onboarding flow
│   │   └── OnboardingView.swift
│   │
│   ├── Auth/                   # Authentication screens
│   │   ├── WelcomeView.swift
│   │   ├── LoginView.swift
│   │   ├── SignupView.swift
│   │   └── AddressSetupView.swift
│   │
│   ├── Main/                   # Main app screens
│   │   ├── MainView.swift
│   │   ├── RequestFormView.swift
│   │   ├── OrderStatusView.swift
│   │   ├── PaymentSheet.swift
│   │   └── AddressEditorView.swift
│   │
│   ├── History/                # Order history screens
│   │   ├── HistoryView.swift
│   │   └── JobDetailView.swift
│   │
│   └── Profile/                # Profile and settings screens
│       ├── ProfileView.swift
│       ├── EditProfileView.swift
│       ├── AddressManagementView.swift
│       └── PaymentMethodView.swift
│
├── Services/                    # Business logic and API layer
│   ├── APIClient.swift         # Stubbed API client
│   ├── OrderService.swift      # Order management with status simulation
│   ├── PaymentService.swift    # Payment processing (stubbed)
│   └── StorageService.swift    # Local data persistence
│
└── Utilities/                   # Helper utilities
    └── Constants.swift         # App constants, colors, pricing engine
```

## Architecture

### MVVM Pattern
The app follows the Model-View-ViewModel (MVVM) architectural pattern:

- **Models**: Plain data structures (User, Job, Address, etc.)
- **ViewModels**: ObservableObject classes that manage state and business logic
- **Views**: SwiftUI views that observe ViewModels and render UI

### Key Features

#### 1. Authentication Flow
- Onboarding carousel (skippable)
- Login/Signup screens
- Initial address setup
- Session persistence using StorageService

#### 2. Order Creation
- Job type selection (Driveway, Walkway, Both, Full Property)
- Snow depth selection (Light, Moderate, Heavy)
- Real-time price calculation using PricingEngine
- Payment processing with validation
- Order submission with stubbed backend

#### 3. Status Tracking
- Simulated status progression (Pending → Confirmed → In Progress → Completed)
- Visual timeline showing job progress
- Automatic status updates via Timer (for demo purposes)
- Notification simulation

#### 4. Order History
- List of past jobs with status badges
- Summary statistics (total jobs, total spent)
- Detailed job view with feedback option
- Thumbs up/down feedback mechanism

#### 5. Profile Management
- User information editing
- Service address management
- Payment method management
- Notification preferences
- Support contact info

### Data Flow

1. **User Actions** → Views capture user input
2. **Views** → Call ViewModel methods
3. **ViewModels** → Update state and call Services
4. **Services** → Interact with API (stubbed) or local storage
5. **Services** → Return data to ViewModels
6. **ViewModels** → Update @Published properties
7. **Views** → Automatically re-render with new data

### State Management

- **AuthViewModel**: Global authentication state
- **OrderViewModel**: Current order state and creation
- **OrderService**: Singleton managing active job and history
- **StorageService**: Singleton for local persistence

### Stubbed Backend

All network calls are simulated for MVP:
- `APIClient`: Returns mock data after delays
- `OrderService`: Simulates status progression with timers
- `PaymentService`: Validates and "processes" payments locally
- Ready for real backend integration by replacing stub implementations

### Pricing Engine

Located in `Constants.swift`:
- Base price: $25
- Job type multipliers (Driveway: 1.0x, Walkway: 0.6x, Both: 1.5x, Full: 2.0x)
- Snow depth multipliers (Light: 1.0x, Moderate: 1.3x, Heavy: 1.8x)
- Final price rounded to nearest $5

### Design System

Defined in `Colors` enum in Constants.swift:
- Primary: Winter Blue (#3380CC)
- Secondary: Warm Orange (#FF9933)
- Accent: Light Blue (#4DB3E6)
- Background: Snow White (#FAFAFF)
- Semantic colors: Success (green), Warning (orange), Error (red)

### Data Persistence

Using UserDefaults via StorageService:
- Current user session
- Authentication token (for future)
- Job history (up to 50 jobs)
- All data encoded/decoded as JSON

### Future Integration Points

To connect to a real backend:

1. **Authentication**: Replace `APIClient.login/signup` with real API calls
2. **Orders**: Replace `APIClient.createJob` with real endpoint
3. **Status Updates**: Replace timer-based simulation with WebSocket or push notifications
4. **Payments**: Integrate Stripe SDK or Apple Pay properly
5. **History**: Fetch from backend instead of local storage only

## Building the App

See `README.md` for detailed build instructions and requirements.

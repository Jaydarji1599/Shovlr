# Shovlr - On-Demand Snow Removal iOS App

[![Platform](https://img.shields.io/badge/platform-iOS-blue.svg)](https://www.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-green.svg)](https://developer.apple.com/xcode/swiftui/)

Shovlr is an on-demand snow removal service app for iOS, built with SwiftUI. Homeowners can request snow clearing services at the tap of a button, with upfront pricing and real-time status tracking.

## 🎯 Features

### Core Functionality
- **On-Demand Requests**: Quick snow removal service requests
- **Upfront Pricing**: Transparent pricing based on job type and snow depth
- **Status Tracking**: Real-time job status updates with visual timeline
- **Order History**: Complete history of past snow removal jobs
- **User Feedback**: Simple thumbs up/down rating system
- **Secure Payments**: Credit card payment processing (stubbed for MVP)
- **Profile Management**: Manage address, payment methods, and preferences

### User Experience
- Clean, winter-themed interface
- Intuitive tab-based navigation
- Accessibility support (VoiceOver, Dynamic Type)
- Onboarding flow for new users
- Session persistence

## 📱 Screenshots

*(Screenshots would go here in a production README)*

## 🏗️ Architecture

The app is built using:
- **SwiftUI** for UI
- **MVVM** architectural pattern
- **Combine** for reactive programming
- **UserDefaults** for local persistence
- Stubbed backend services (ready for real API integration)

See [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) for detailed architecture documentation.

## 🚀 Getting Started

### Prerequisites

- Xcode 15.0 or later
- iOS 17.0 or later
- macOS Sonoma 14.0 or later

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/shovlr.git
   cd shovlr
   ```

2. **Open in Xcode**
   ```bash
   open Shovlr.xcodeproj
   ```

   If you don't have an Xcode project file yet, create one:
   - Open Xcode
   - File → New → Project
   - Choose "App" template
   - Product Name: "Shovlr"
   - Interface: SwiftUI
   - Life Cycle: SwiftUI App
   - Language: Swift
   - Add all files from `ShovlrApp/` directory to the project

3. **Configure Bundle Identifier**
   - Select the project in Project Navigator
   - Change the Bundle Identifier to your own (e.g., `com.yourcompany.shovlr`)

4. **Run the app**
   - Select a simulator or physical device
   - Press `Cmd + R` to build and run

### Project Setup in Xcode

If creating a new Xcode project:

1. Create the project with the settings above
2. Delete the default `ContentView.swift` if it conflicts
3. Add all folders from `ShovlrApp/` to your project:
   - Drag and drop into Xcode
   - Ensure "Copy items if needed" is checked
   - Select "Create groups"
   - Add to target: Shovlr

4. Replace the default `Info.plist` with the one provided

5. File structure in Xcode should match:
   ```
   Shovlr/
   ├── ShovlrApp.swift
   ├── ContentView.swift
   ├── Models/
   ├── ViewModels/
   ├── Views/
   ├── Services/
   ├── Utilities/
   └── Info.plist
   ```

## 💳 Demo Credentials

For testing the app (MVP with stubbed backend):

- **Login**: Any phone number and password will work
- **Payment**: Use test card `4242 4242 4242 4242` (any future expiry, any CVV)
- **Address**: Any Halifax, NS address

## 🎨 Design

The app features a winter-themed design:
- **Primary Color**: Winter Blue (#3380CC)
- **Secondary Color**: Warm Orange (#FF9933) for calls-to-action
- **Background**: Snow White (#FAFAFF)
- Clean, minimal interface focused on core functionality

## 📋 User Flow

1. **Onboarding** (first launch)
   - View benefits carousel
   - Skip or complete

2. **Authentication**
   - Sign up with name, phone, and password
   - Add service address
   - (Optional) Add payment method

3. **Request Snow Removal**
   - Select job type (Driveway, Walkway, Both, Full Property)
   - Select snow depth (Light, Moderate, Heavy)
   - See upfront price calculation
   - Add special instructions (optional)
   - Enter payment details
   - Confirm request

4. **Track Job Status**
   - View real-time status (Pending → Confirmed → In Progress → Completed)
   - See visual timeline
   - Review job details

5. **View History**
   - See all past jobs
   - View summary statistics
   - Rate completed jobs
   - View detailed receipts

6. **Manage Profile**
   - Edit personal information
   - Update service address
   - Manage payment methods
   - Adjust notification preferences

## 🔧 Configuration

### Pricing Configuration

Pricing is configured in `Utilities/Constants.swift`:

```swift
private static let basePrice: Double = 25.0

private static let jobTypeMultipliers: [JobType: Double] = [
    .driveway: 1.0,
    .walkway: 0.6,
    .both: 1.5,
    .fullProperty: 2.0
]

private static let snowDepthMultipliers: [SnowDepth: Double] = [
    .light: 1.0,
    .moderate: 1.3,
    .heavy: 1.8
]
```

### Status Update Timing

For the demo, status updates are simulated with delays:

```swift
enum AppConstants {
    static let statusUpdateDelay: TimeInterval = 10 // seconds between status updates
    static let autoCompleteDelay: TimeInterval = 30 // seconds until auto-complete
}
```

Adjust these in production when connecting to a real backend.

## 🔌 Backend Integration

The app is designed for easy backend integration. Key integration points:

### 1. Authentication
Replace stub in `Services/APIClient.swift`:
```swift
func login(phone: String, password: String) async throws -> User {
    // Replace with real API call
    let response = try await networkClient.post("/auth/login", ...)
    return User(from: response)
}
```

### 2. Order Creation
```swift
func createJob(_ job: Job) async throws -> Job {
    // Replace with real API call
    let response = try await networkClient.post("/orders", body: job)
    return Job(from: response)
}
```

### 3. Status Updates
Replace timer-based simulation in `Services/OrderService.swift` with:
- WebSocket connection for real-time updates
- Push notifications via APNs
- Polling (less ideal but simpler)

### 4. Payment Processing
Integrate Stripe SDK:
```swift
import Stripe

// Configure Stripe
StripeAPI.defaultPublishableKey = "your_publishable_key"

// Process payment
let paymentIntent = try await StripeAPI.confirmPayment(...)
```

Or use Apple Pay for seamless checkout.

## 📦 Dependencies

Currently, the app has no external dependencies (pure SwiftUI). For production, consider adding:

- **Stripe**: Payment processing
- **Firebase**: Analytics, Crashlytics, Push Notifications
- **Alamofire** or **URLSession**: Enhanced networking
- **Kingfisher**: Image loading (if adding provider photos)

## 🧪 Testing

The app includes:
- SwiftUI Previews for all major views
- Stubbed services for UI testing
- Form validation
- Error handling

To add unit tests:
1. Create a test target in Xcode
2. Write tests for ViewModels and Services
3. Mock APIClient for testing

## 🚧 Roadmap

### Phase 1: MVP (Current)
- ✅ User authentication
- ✅ Service request with pricing
- ✅ Status tracking (simulated)
- ✅ Order history
- ✅ User feedback
- ✅ Profile management

### Phase 2: Backend Integration
- [ ] Real API integration
- [ ] Live status updates via WebSocket
- [ ] Push notifications
- [ ] Stripe payment integration
- [ ] User verification (SMS/Email)

### Phase 3: Enhanced Features
- [ ] Schedule future snow removals
- [ ] Multiple saved addresses
- [ ] Provider profiles and ratings
- [ ] Live GPS tracking
- [ ] In-app chat with provider
- [ ] Promotional codes and discounts

### Phase 4: Scale
- [ ] Android app
- [ ] Provider-facing app
- [ ] Automated dispatch system
- [ ] Service area expansion
- [ ] Recurring service subscriptions

## 📄 License

[Add your license here]

## 👥 Contributors

[Add contributors here]

## 📞 Support

For support and questions:
- **Email**: support@shovlr.ca
- **Phone**: 1-902-555-SNOW

## 🙏 Acknowledgments

Built based on the successful MVP trial in Halifax, NS. Designed to scale from a manual dispatch model to a fully automated on-demand platform.

---

**Note**: This is an MVP with stubbed backend services. All network calls and payment processing are simulated for demonstration purposes. Real backend integration is required for production deployment.

# Shovlr - Quick Start Guide

## 🚀 Get Up and Running in 5 Minutes

### Step 1: Open Xcode
```bash
# Open Xcode (version 15.0 or later required)
open -a Xcode
```

### Step 2: Create New Project
1. File → New → Project
2. Select **"App"** template
3. Configure:
   - **Product Name**: Shovlr
   - **Interface**: SwiftUI
   - **Life Cycle**: SwiftUI App
   - **Language**: Swift
   - **Team**: Select your team
   - **Bundle Identifier**: com.yourcompany.shovlr

### Step 3: Add Source Files
1. Delete the default `ContentView.swift` file that Xcode created
2. In Finder, navigate to your cloned repository
3. Drag the entire `ShovlrApp` folder into your Xcode project
4. When prompted:
   - ✅ Check "Copy items if needed"
   - ✅ Select "Create groups"
   - ✅ Add to target: Shovlr

### Step 4: Replace Info.plist
1. Delete the default Info.plist in your Xcode project
2. The Info.plist from ShovlrApp will be used

### Step 5: Build and Run
1. Select a simulator (iPhone 15 recommended) or physical device
2. Press `⌘ + R` or click the Play button
3. Wait for build to complete (~30 seconds first time)

## 🎉 You're Done!

The app will launch in the simulator. You'll see:
1. Onboarding screens (swipe through or skip)
2. Welcome screen with "Create Account" and "Log In"

## 🧪 Test the App

### Create an Account
1. Tap "Create Account"
2. Enter any details:
   - Name: Your Name
   - Phone: 902-555-1234 (any number works)
   - Password: test123 (any password works)
3. Tap "Sign Up"
4. Add an address:
   - Street: 123 Main St
   - City: Halifax
   - Province: NS
   - Postal Code: B3H 1A1
5. Tap "Save Address"

### Request Snow Removal
1. On Home screen, select:
   - Job Type: "Driveway & Walkway"
   - Snow Depth: "Heavy"
2. See price update to $67.50
3. Tap "Request Snow Removal"
4. Enter payment:
   - Card: 4242 4242 4242 4242
   - Expiry: 12/25
   - CVV: 123
5. Tap "Pay"

### Watch Status Updates
- Status will automatically progress every 10 seconds:
  - Pending → Confirmed → In Progress → Completed
- Notifications are logged to Xcode console

### View History
1. Tap "History" tab
2. See your completed job
3. Tap on the job to see details
4. Rate the service with thumbs up/down

### Manage Profile
1. Tap "Profile" tab
2. Edit your information
3. Update address
4. Manage payment method
5. Toggle notifications

## 📝 Important Notes

### For MVP Testing
- **Authentication**: Any phone/password works (stubbed)
- **Payment**: Use test card 4242424242424242 (stubbed)
- **Status Updates**: Automatic every 10 seconds (demo mode)
- **Backend**: All services are stubbed/simulated

### File Structure in Xcode
Your project should look like:
```
Shovlr (project)
├── ShovlrApp.swift          ← Main entry
├── ContentView.swift        ← Tab navigation
├── Info.plist
├── Models (folder)
├── ViewModels (folder)
├── Views (folder)
│   ├── Auth
│   ├── Components
│   ├── History
│   ├── Main
│   ├── Onboarding
│   └── Profile
├── Services (folder)
└── Utilities (folder)
```

## 🐛 Troubleshooting

### Build Errors?
1. **"No such module"**: Clean build folder (⌘ + Shift + K)
2. **Signing errors**: Select your development team in project settings
3. **File not found**: Ensure all files are added to target

### App Won't Launch?
1. Check iOS Deployment Target is set to 17.0+
2. Restart Xcode
3. Clean derived data: `~/Library/Developer/Xcode/DerivedData`

### Simulator Issues?
1. Try a different simulator device
2. Restart the simulator: Device → Erase All Content and Settings
3. Quit and reopen Xcode

## 🎨 Customization

### Change Pricing
Edit `ShovlrApp/Utilities/Constants.swift`:
```swift
static let basePrice: Double = 25.0  // Change base price

// Adjust multipliers
private static let jobTypeMultipliers: [JobType: Double] = [
    .driveway: 1.0,
    .walkway: 0.6,
    .both: 1.5,
    .fullProperty: 2.0
]
```

### Adjust Demo Speed
Edit `ShovlrApp/Utilities/Constants.swift`:
```swift
// Faster status updates (5 seconds)
static let statusUpdateDelay: TimeInterval = 5

// Slower status updates (30 seconds)
static let statusUpdateDelay: TimeInterval = 30
```

### Change Colors
Edit `ShovlrApp/Utilities/Constants.swift`:
```swift
enum Colors {
    static let primary = Color(red: 0.2, green: 0.5, blue: 0.8)
    static let secondary = Color(red: 1.0, green: 0.6, blue: 0.2)
    // ...customize other colors
}
```

## 📱 Test on Physical Device

1. Connect iPhone via USB
2. Select your iPhone in device menu
3. If needed, register device in Apple Developer Portal
4. Build and run (⌘ + R)

## 🔄 Next Steps

1. ✅ **Test all flows** in the app
2. 📱 **Take screenshots** for App Store
3. 🔌 **Plan backend** integration
4. 💳 **Set up Stripe** account for payments
5. 🚀 **Prepare for** App Store submission

## 📚 More Information

- Full documentation: `README.md`
- Architecture details: `PROJECT_STRUCTURE.md`
- Implementation notes: `IMPLEMENTATION_SUMMARY.md`

## 💬 Demo Credentials

**Works for any values in MVP:**
- Phone: 902-555-1234
- Password: test123
- Card: 4242 4242 4242 4242
- Expiry: 12/25
- CVV: 123

## 🎯 Key Features to Test

- [x] Onboarding flow
- [x] Sign up and login
- [x] Address setup
- [x] Job type selection
- [x] Real-time pricing
- [x] Payment entry
- [x] Status tracking
- [x] History viewing
- [x] Job feedback
- [x] Profile editing
- [x] Address management
- [x] Payment management

---

**Need Help?**
- Check the full README.md for detailed instructions
- Review IMPLEMENTATION_SUMMARY.md for technical details
- All code includes inline documentation

**Happy Testing!** 🎉

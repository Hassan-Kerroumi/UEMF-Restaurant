# Login Screen Documentation

## Overview
The login screen serves as the entry point for the Restaurant Admin app. It handles authentication and routes users to the appropriate interface based on their credentials.

## Features

### 🔐 Authentication
- Email/Username and Password fields
- Form validation:
  - Email/Username: Required
  - Password: Minimum 6 characters
- Password visibility toggle
- Loading state during authentication

### 🚦 Smart Routing
- **Admin Access**: If email/username contains "admin" → Routes to Admin App
- **Regular User**: Otherwise → Routes to User App (placeholder)

### 🎨 Design
- Matches app's dark theme color scheme
- Responsive layout with SingleChildScrollView
- Elegant input fields with focus states
- Disabled state handling during loading

## Color Scheme

```dart
Background: #0e1116 (Dark Blue-Gray)
Input Fields: #1a1f2e (Card Background)
Primary Button: #c74242 (Red)
Success Hint: #3cad2a (Green)
Text: #f9fafb (Light Gray)
Muted Text: #9ca3af (Medium Gray)
```

## Usage

### Test Credentials

**Admin Access:**
- Email: `admin@restaurant.com` (or any email containing "admin")
- Password: Any 6+ characters

**User Access:**
- Email: `user@restaurant.com` (any email NOT containing "admin")
- Password: Any 6+ characters

## File Structure

```
lib/
└── login/
    └── login_screen.dart
```

## Code Flow

1. User enters email/username and password
2. Form validation triggered
3. If valid:
   - Show loading indicator
   - Simulate network delay (1 second)
   - Check if email contains "admin"
   - Route accordingly
4. If invalid:
   - Show error messages

## Validation Rules

### Email/Username
- Cannot be empty
- Trimmed and converted to lowercase

### Password
- Cannot be empty
- Minimum 6 characters

## UI Components

### Input Fields
- Prefix icons (email, lock)
- Floating labels
- Focus border animation (red: #c74242)
- Error states (red: #ef4444)

### Login Button
- Full-width button
- Loading state with circular progress indicator
- Disabled during authentication
- Elevation and shadow effects

### Additional Elements
- Forgot Password link (placeholder)
- Sign Up link (placeholder)
- Quick Access info box with admin hint

## Future Enhancements

- [ ] API integration for real authentication
- [ ] JWT token storage
- [ ] Remember me checkbox
- [ ] Biometric authentication
- [ ] Social login (Google, Facebook)
- [ ] Password strength indicator
- [ ] Email format validation
- [ ] Password reset flow
- [ ] User registration flow

## Example Usage in Code

```dart
// In main.dart
import 'login/login_screen.dart';

// Set as home screen
home: const LoginScreen(),
```

## Navigation Logic

```dart
if (email.contains('admin')) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => const AdminMain()),
  );
} else {
  // Navigate to User App (coming soon)
}
```

## Screenshots Description

1. **Initial State**: Clean form with email and password fields
2. **Focus State**: Input field highlighted with red border (#c74242)
3. **Error State**: Validation messages below fields
4. **Loading State**: Button shows circular progress indicator
5. **Success**: Navigates to appropriate app

## Accessibility

- Semantic labels for screen readers
- Keyboard navigation support
- Clear error messages
- Sufficient touch targets (56px height for button)
- High contrast text and borders

# Restaurant Admin App - Flutter

This Flutter app is a recreation of the admin panel from the React/Figma version, designed specifically for restaurant administrators to manage orders, view statistics, and handle products.

## Features

### 0. **Login Screen** (`login_screen.dart`) 🆕
- Email/Username and Password authentication
- Smart routing: Admins → Admin App, Users → User App
- Form validation with error messages
- Password visibility toggle
- Loading states
- **Test Credentials**:
  - Admin: `admin@restaurant.com` / password: `123456`
  - User: `user@restaurant.com` / password: `123456`

### 1. **Admin Home** (`admin_home_screen.dart`)
- View today's orders
- Search orders
- Filter by categories (Coffee, Breakfast, Lunch, Pastry)
- Accept/Refuse orders
- Suggest alternative pickup times
- Status-based color coding (Pending, Accepted, Refused)

### 2. **Admin Stats** (`admin_stats_screen.dart`)
- Key metrics dashboard (Total Orders, Revenue, Avg Wait Time, Active Users)
- Revenue & Customer Trends Chart (Month/Year view)
- Most Ordered Items with visual progress bars
- Orders by Time bar chart
- All charts powered by `fl_chart` package

### 3. **Admin Products** (`admin_products_screen.dart`)
- View all products in grid layout
- Search products
- Filter by category
- **Add new products** with image picker (Gallery)
- **Edit existing products** (Names, Price, Image, Category)
- Delete products with confirmation
- Multi-language support (EN/FR/AR)

## Dependencies

- `flutter`: SDK
- `fl_chart: ^0.69.0`: For charts and graphs in statistics
- `google_fonts: ^6.1.0`: For Poppins font family
- `provider: ^6.1.1`: State management
- `image_picker: ^1.0.7`: Image selection from gallery
- `cupertino_icons: ^1.0.8`: iOS-style icons

The app follows the exact color scheme from the React app:

```dart
Background: #0e1116 (Dark Blue-Gray)
Card Background: #1a1f2e (Lighter Blue-Gray)
Primary (Red): #c74242
Success (Green): #3cad2a
Text: #f9fafb (Light Gray)
Muted Text: #9ca3af (Medium Gray)
Border: rgba(255, 255, 255, 0.1)
```

### Typography
- **Font Family**: Poppins
- **Weights**: Regular (400), Medium (500), SemiBold (600)

## Setup Instructions

### 1. Install Dependencies
```bash
cd mobiledev
flutter pub get
```

### 2. Add Poppins Font
Download Poppins font from [Google Fonts](https://fonts.google.com/specimen/Poppins) and add these files to `assets/fonts/`:
- `Poppins-Regular.ttf` (weight 400)
- `Poppins-Medium.ttf` (weight 500)
- `Poppins-SemiBold.ttf` (weight 600)

Alternatively, run:
```bash
# Create fonts directory
mkdir -p assets/fonts

# Download and extract (you may need to do this manually)
# Visit https://fonts.google.com/specimen/Poppins
# Download the font family and extract the required weights
```

### 3. Run the App
```bash
flutter run
```

## Project Structure

```
lib/
├── login/
│   └── login_screen.dart         # Authentication screen
├── admin/
│   ├── admin_main.dart           # Main navigation with bottom tabs
│   ├── admin_home_screen.dart    # Orders management
│   ├── admin_stats_screen.dart   # Statistics & analytics
│   └── admin_products_screen.dart # Product management
└── main.dart                      # App entry point
```

## Dependencies

- `flutter`: SDK
- `fl_chart: ^0.69.0`: For charts and graphs in statistics
- `google_fonts: ^6.1.0`: For Poppins font family
- `cupertino_icons: ^1.0.8`: iOS-style icons

## Key Differences from React Version

1. **Navigation**: Uses bottom navigation bar instead of side tabs
2. **Dialogs**: Native Flutter dialogs instead of web modals
3. **Charts**: Uses `fl_chart` instead of `recharts`
4. **State Management**: Local state with `setState` (can be upgraded to Provider/Riverpod)
5. **Responsive**: Optimized for mobile screens

## Future Enhancements

- API integration for real data
- Authentication system
- Push notifications for new orders
- Order history search
- Analytics export
- Multi-language support (currently EN/FR/AR ready)
- Dark/Light theme toggle

## Colors Reference

| Element | Light Mode | Dark Mode (Current) |
|---------|-----------|---------------------|
| Background | #ffffff | #0e1116 |
| Card | #ffffff | #1a1f2e |
| Primary | #c74242 | #c74242 |
| Success | #3cad2a | #3cad2a |
| Text | #1a1a1a | #f9fafb |
| Muted | #6b7280 | #9ca3af |

## Notes

- The app currently uses mock data
- All designs respect the original Figma/React specifications
- Font sizes, spacing, and colors match the React version
- Charts are responsive and interactive

#!/bin/bash

# Script to download and setup Poppins font for Flutter app

echo "Setting up Poppins font..."

# Create fonts directory
mkdir -p assets/fonts

echo "Please download Poppins font manually:"
echo "1. Visit: https://fonts.google.com/specimen/Poppins"
echo "2. Click 'Download family'"
echo "3. Extract the ZIP file"
echo "4. Copy these files to assets/fonts/:"
echo "   - Poppins-Regular.ttf"
echo "   - Poppins-Medium.ttf"  
echo "   - Poppins-SemiBold.ttf"
echo ""
echo "Or use Google Fonts package (alternative):"
echo "Add to pubspec.yaml dependencies:"
echo "  google_fonts: ^6.1.0"
echo ""
echo "Then in main.dart, use:"
echo "  fontFamily: GoogleFonts.poppins().fontFamily"

# Running the App on Emulator

## Step 1: Start the Emulator (Already Started)
The emulator "Medium_Phone_API_36.1" is starting. Wait for it to fully boot (you'll see the Android home screen).

## Step 2: Find Flutter Installation
If Flutter is not in your PATH, you need to find where it's installed. Common locations:
- `C:\src\flutter\bin\flutter.bat`
- `C:\flutter\bin\flutter.bat`
- Or check where you installed Flutter

## Step 3: Run the App

### Option A: If Flutter is in PATH
```bash
cd C:\Users\Arslene\Desktop\ate\ate_app
flutter devices
flutter run
```

### Option B: If Flutter is NOT in PATH
1. Find your Flutter installation path (e.g., `C:\src\flutter`)
2. Use the full path:
```bash
cd C:\Users\Arslene\Desktop\ate\ate_app
C:\src\flutter\bin\flutter.bat devices
C:\src\flutter\bin\flutter.bat run
```

### Option C: Using Android Studio
1. Open Android Studio
2. Open the project: `C:\Users\Arslene\Desktop\ate\ate_app`
3. Wait for Flutter to sync
4. Click the "Run" button (green play icon) or press Shift+F10

## Step 4: Select the Emulator
When prompted, select the running emulator from the list.

## Troubleshooting

### If emulator doesn't appear:
1. Check if emulator is fully booted (wait 1-2 minutes)
2. Run: `flutter doctor` to check Flutter setup
3. Make sure Android SDK is properly configured

### If you get "No devices found":
1. Wait for emulator to fully boot
2. Run: `adb devices` to see connected devices
3. Restart the emulator if needed

### To stop the emulator:
- Close the emulator window, or
- Run: `adb emu kill`



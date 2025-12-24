# Quick Start Guide - Run on Emulator

## Method 1: Using the Batch Script (Easiest)

1. **Make sure the emulator is running** (you should see the Android emulator window)
2. **Double-click** `run_emulator.bat` in the `ate_app` folder
3. Wait for the app to build and install on the emulator

## Method 2: Manual Command

1. **Open PowerShell or Command Prompt**
2. **Navigate to the project:**
   ```bash
   cd C:\Users\Arslene\Desktop\ate\ate_app
   ```

3. **Check if emulator is ready:**
   ```bash
   C:\flutter\bin\flutter.bat devices
   ```
   You should see `emulator-5554` in the list

4. **Run the app:**
   ```bash
   C:\flutter\bin\flutter.bat run
   ```

## Method 3: Using Android Studio

1. **Open Android Studio**
2. **File → Open** → Select `C:\Users\Arslene\Desktop\ate\ate_app`
3. **Wait for Flutter to sync** (bottom right corner)
4. **Click the green "Run" button** or press `Shift+F10`
5. **Select the emulator** from the device list

## Troubleshooting

### Emulator not showing up?
- Wait 1-2 minutes for the emulator to fully boot
- Check if emulator window is open and showing Android home screen
- Run: `C:\flutter\bin\flutter.bat doctor` to check setup

### "No devices found" error?
- Make sure emulator is fully booted (not just starting)
- Try: `adb devices` to see connected devices
- Restart the emulator if needed

### Build errors?
- Run: `C:\flutter\bin\flutter.bat clean`
- Then: `C:\flutter\bin\flutter.bat pub get`
- Then try running again

## Current Status

✅ Flutter found at: `C:\flutter`
✅ Emulator available: `Medium_Phone_API_36.1`
✅ Project location: `C:\Users\Arslene\Desktop\ate\ate_app`

**Next Step:** Wait for the emulator to fully boot (you'll see the Android home screen), then run the app using one of the methods above!



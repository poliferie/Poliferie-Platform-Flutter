# Poliferie.io - Poliferie platform for Italian universities.

This project is a first draft for the cross-platform Poliferie Platform App.
It is written in Dart using [Flutter](https://flutter.io).

## Contributing

* Fork the repository and clone it to your local machine
* Follow the instructions [here](https://flutter.io/docs/get-started/install)
  to install the Flutter SDK
* Setup [Android Studio](https://flutter.io/docs/development/tools/android-studio)
  or [Visual Studio Code](https://flutter.io/docs/development/tools/vs-code).

## Usage
Update and check flutter installations first.

'''sh
flutter upgrade
flutter doctor
'''

### Run on emulator
Start Android emulator first via the GUI interface of Android Studio. 
Check device id via

'''sh
flutter devices
'''

Then launch project into the target Android emulator.

'''sh
flutter run -d emulator-5554
'''

### Run on usb connected device
Dive into Developer options on your device, and be sure to have
'USB debugging' enabled. Then connect your device via a usb cable
and launch the app via flutter.

'''sh
flutter run
'''

In case you encounter permission errors, kill the adb server,
and respwan it with root privileges.

'''sh
adb kill-server
sudo adb usb
'''

Then run flutter again.

## Known issues
Flutter does not seems to play well with Linux kernel 5.5 and above,
as the flutter run process will get stuck on 'syncing files to device'.
So please wait for a fix on this.

* https://github.com/flutter/flutter/issues/49185



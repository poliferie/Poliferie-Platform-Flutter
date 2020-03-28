# Poliferie.io - Poliferie platform for Italian universities.

This project is a first draft for the cross-platform Poliferie Platform App.
It is written in Dart using [Flutter](https://flutter.io).

## Contributing

* Fork the repository and clone it to your local machine
* Follow the instructions [here](https://flutter.io/docs/get-started/install)
  to install the Flutter SDK
* Setup [Android Studio](https://flutter.io/docs/development/tools/android-studio)
  or [Visual Studio Code](https://flutter.io/docs/development/tools/vs-code).

Check out the `CONTRIBUTING.md` file on what it has to be done.

## Usage
Make sure you have Flutter installed on your local machine.
For more instructions on how to install flutter, look [here](https://flutter.io/docs/get-started/install).

Clone this repository and move into the project folder.

```sh
git clone https://github.com/poliferie/Poliferie-Platform-Flutter
cd Poliferie-Platform-Flutter
```

Then, update and check the flutter installation.

```sh
flutter upgrade
flutter doctor
```

### Run on the Android emulator
Start the Android emulator first via Android Studio.
Check device id.

```sh
flutter devices
```

Then build and deploy the app into the target device.

```sh
flutter run -d emulator-5554
```

### Run on a usb connected device
Dive into Developer options on your device, and be sure to have
'USB debugging' enabled. Then connect your device via a usb cable
and launch the app via flutter.

```sh
flutter run
```

In case you encounter permission errors, kill the adb server,
and respwan it with root privileges.

```sh
adb kill-server
sudo adb usb
```

Then run flutter again.

## Known issues
Flutter does not play well with the Linux kernel 5.5 and above,
as the flutter run process will get stuck on 'syncing files to device'.
Please get updates via the GitHub [issue](https://github.com/flutter/flutter/issues/49185).
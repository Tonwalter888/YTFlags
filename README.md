# YTFlags
Currently, these hooks are based on YouTube versions 19.49.5, 20.21.6, 21.04.2, 21.06.2, 21.10.2 and 21.13.6. I'll keep updaing the flags if the newer version comes out. This project is similar to [YTABGoodies](https://github.com/PoomSmart/YTABGoodies) by [PoomSmart](https://github.com/PoomSmart) and tries to enable useful YouTube features that are avaliable to you.

## Features (100% Verified)
- Remove video ads
- Enables PiP (Picture-In-Picture)
- Allows background playback
- Fix playback issues (For jailbroken and TrollStore users only)
- Hide the "Are you there?" dialog
- Hide upgrade dialogs
- Hide YouTube Premium promotions
- Uses/Restores old miniplayer (Only for older YouTube versions)
- Fixes miniplayer working slowly (Only for older YouTube versions)
- Disables snack bar

## Building
1. Clone [Theos](https://github.com/theos/theos) along with its submodules.
2. Clone and copy [iOS 18.6 SDK](https://github.com/Tonwalter888/iOS-SDKs) to ``$THEOS/sdks``.
3. Clone [YouTubeHeader](https://github.com/PoomSmart/YouTubeHeader) and [PSHeader](https://github.com/PoomSmart/PSHeader) into ``$THEOS/include``.
4. Clone YTFlags, cd into it and run
- ``make clean package DEBUG=0 FINALPACKAGE=1`` For rootful jailbroken iOS (iOS <15 - checkra1n, Cydia)
- ``make clean package DEBUG=0 FINALPACKAGE=1 THEOS_PACKAGE_SCHEME=rootless`` For rootless jailbroken iOS (iOS 15+ - palera1n, Sileo, Zebra, Dolpamine, bakera1n, TrollStore)
- ``make clean package DEBUG=0 FINALPACKAGE=1 THEOS_PACKAGE_SCHEME=roothide`` For roothide jailbroken iOS (iOS 15 - Dolpamine, Bootstrap)

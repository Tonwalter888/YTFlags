# YTFlags
Currently, these hooks are based on YouTube versions 19.49.5 and 20.21.6. The latest version will be added soon. This project is similar to [YTABGoodies](https://github.com/PoomSmart/YTABGoodies) by [PoomSmart](https://github.com/PoomSmart).

This project tries to enable useful YouTube features that are avaliable to you.

## Features (100% Verified)
- Enables PiP (Picture-In-Picture)
- Allow Background Playbacks
- Fix playback issues (For jailbroken and TrollStore users only)
- Hide a prompt "Are you there?"
- Fix miniplayer working slowly (Only for older YouTube versions)

## Building
- Clone [Theos](https://github.com/theos/theos) along with its submodules.
- Clone and copy [iOS 18.6 SDK](https://github.com/Tonwalter888/iOS-18.6-SDK) to ``$THEOS/sdks``.
- Clone YTFlags, cd into it and run ``make clean package DEBUG=0 FINALPACKAGE=1 THEOS_PACKAGE_SCHEME=rootless``. (You can remove the ``THEOS_PACKAGE_SCHEME=rootless`` part if you are using in jailbroken iOS.)

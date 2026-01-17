# YTFlags

Currently these hooks are based on YouTube versions 19.49.5 and 20.21.6. I'll add the latest version soon. This project is similar to [YTABGoodies](https://github.com/PoomSmart/YTABGoodies) from PoomSmart.

This project tries to enforce useful YouTube features that are otherwise 50/50 available to you.

## Building
- Clone [Theos](https://github.com/theos/theos).
- Clone and Copy [iOS 18.6 SDK](https://github.com/xybp888/iOS-SDKs) to ``$THEOS/sdks``.
- Cd into YTFlags and run ``make clean package DEBUG=0 FINALPACKAGE=1 THEOS_PACKAGE_SCHEME=rootless``. (You can remove the ``THEOS_PACKAGE_SCHEME=rootless`` part if you are using in jailbroken iOS.)

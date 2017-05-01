# Telegram-FOSS

[Telegram](https://telegram.org) is a messaging app with a focus on speed and security. It’s superfast, simple and free.

This is an unofficial, FOSS-friendly fork of the original [Telegram App for Android](https://github.com/DrKLO/Telegram).

**Changes:**

*Replacement of non-FOSS, untrustworthy or suspicious binaries or source code:*
- Do location sharing with OpenStreetMap instead of Google Maps (thermatk)
- Use emojiOne emoji set instead of Apple's emoji (thermatk)
- Google Play Services GCM replaced with always-on Telegram's push service (slp)
- BoringSSL bundled source and binaries are replaced with upstream OpenSSL source code built at compile time (Bubu)
- FFmpeg prebuilts are replaced with source code built at compile time (slp)
- libtgvoip prebuilts are replaced with source code built at compile time (thermatk)

*Removal of non-FOSS, untrustworthy or suspicious binaries or source code and their functionality:*
- Google Vision face detection
- Bing image search (requires API key)
- Foursquare map search (requires API key)
- HockeyApp crash reporting and self-updates

This version of Telegram is available on FDroid: 

[<img src="https://f-droid.org/badge/get-it-on.png"
      alt="Get it on F-Droid"
      height="80">](https://f-droid.org/app/org.telegram.messenger)

## Versioning

This repository contains tags to make tracking versions easier.

Versions are in form "v$UPSTREAM$RELEASE" where:

* $UPSTREAM is the public, visible version of upstream.
* $RELEASE is a letter ([a-z]) indicating minor releases between official versions (sometimes, upstream is updated without relating the changes to an specific version).

## API, Protocol documentation

Telegram API manuals: https://core.telegram.org/api

MTproto protocol manuals: https://core.telegram.org/mtproto

## Building

**Important:**
1. You need the [Android-NDK](https://developer.android.com/ndk/downloads/index.html) to build the apk.

2. If you want to publish a modified version of Telegram:
      - You should get **your own API key** here: https://core.telegram.org/api/obtaining_api_id and update the file `src/main/java/org/telegram/messenger/BuildVars.java` accordingly
      - Do not use the name Telegram and the standard logo (white paper plane in a blue circle) for your app — or make sure your users understand that it is unofficial
      - Take good care of your users' data and privacy
      - **Please remember to publish your code too in order to comply with the licenses**

The project can be built with Android Studio or from the command line with gradle:

`./gradlew assembleFatRelease`

# Telegram-FOSS

[Telegram](https://telegram.org) is a messaging app with a focus on speed and security. It’s superfast, simple and free.

This is an unofficial, FOSS-friendly fork of the original [Telegram App for Android](https://github.com/DrKLO/Telegram).

This version of Telegram is available on FDroid:

[<img src="https://f-droid.org/badge/get-it-on.png"
      alt="Get it on F-Droid"
      height="80">](https://f-droid.org/app/org.telegram.messenger)

## Current Maintainers

- [thermatk](https://github.com/thermatk)
- [Bubu](https://github.com/Bubu)
- you? :)

## Discussion

Join the [Telegram-FOSS Offtopics group](https://t.me/joinchat/AAAAAEFaw9LIC-VgKVCevg)

## Changes:

*Replacement of non-FOSS, untrustworthy or suspicious binaries or source code:*
- Do location sharing with OpenStreetMap(osmdroid) instead of Google Maps
- Use Twemoji emoji set instead of Apple's emoji
- Google Play Services GCM replaced with always-on Telegram's push service
- **SECURITY:** Old BoringSSL prebuilts are replaced with the newest upstream OpenSSL source code built at compile time
- **SECURITY:** Old FFmpeg prebuilts are replaced with the newest upstream source code built at compile time
- **SECURITY:** Bundled SQLite is updated
- **SECURITY:** Bundled libWebP is updated

*Removal of non-FOSS, untrustworthy or suspicious binaries or source code and their functionality:*
- Google Vision face detection
- Google Wallet and Android Pay integration
- Bing image search (would require an API key)
- Foursquare map search (would require an API key)
- HockeyApp crash reporting and self-updates

*Other:*
- Added the ability to parse locations from intents containing a `geo:<lat>,<lon>,<zoom>` string.
- Builds with armv6 support
- Fix calls

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

2. Don't forget to include the submodules when you clone:
      - `git clone --recursive https://github.com/Telegram-FOSS-Team/Telegram-FOSS.git`

3. Build native FFmpeg dependency:
      - Go to the `TMessagesProj/jni` folder and execute the following (define the path to your NDK r14b installation):
      
      ```
      export NDK=[PATH_TO_NDK]
      ./build_ffmpeg_android.sh
      ```

4. If you want to publish a modified version of Telegram:
      - You should get **your own API key** here: https://core.telegram.org/api/obtaining_api_id and create a file called `API_KEYS` in the source root directory.
        The contents should look like this:
        ```
        APP_ID = 12345
        APP_HASH = aaaaaaaabbbbbbccccccfffffff001122
        ```
      - Do not use the name Telegram and the standard logo (white paper plane in a blue circle) for your app — or make sure your users understand that it is unofficial
      - Take good care of your users' data and privacy
      - **Please remember to publish your code too in order to comply with the licenses**

5. Building under Windows may be problematic and won't be fixed

The project can be built with Android Studio or from the command line with gradle:

`./gradlew assembleFatRelease`

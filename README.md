# Telegram-FOSS

[Telegram](https://telegram.org) is a messaging app with a focus on speed and security. It’s superfast, simple and free.

This is an unofficial, FOSS friendly fork of the original [Telegram App for Android](https://github.com/DrKLO/Telegram).

Several proprietary parts were removed from the original Telegram client, including Google Play Services for the location services and HockeySDK for self-updates. Push notifications through Google Cloud Messaging and the automatic SMS receiving features were also removed.

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

The project can be build with Android Studio or from the command line with gradle.

**Important:**
You also need the [Android-NDK](https://developer.android.com/ndk/downloads/index.html) and run `ndk-build` in the TMessagesProj directory before building the apk.

If you want to publish a modified version of Telegram you should get **your own API key** form here: https://core.telegram.org/api/obtaining_api_id.
Then update the file **src/main/java/org/telegram/messenger/BuildVars.java** accordingly.


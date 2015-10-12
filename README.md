## Telegram-FOSS

[Telegram](http://telegram.org) is a messaging app with a focus on speed and security. It’s superfast, simple and free.

This is an unofficial, FOSS friendly fork of the original [Telegram App for Android](https://github.com/DrKLO/Telegram).

Several proprietary parts were removed from the original Telegram client, including Google Play Services for the location services and HockeySDK for self-updates. Push notifications through Google Cloud Messaging and the automatic SMS receiving features were also removed.

### Get it
[![Fdroid](https://f-droid.org/wiki/images/0/06/F-Droid-button_get-it-on.png)](https://f-droid.org/repository/browse/?fdid=org.telegram.messenger)

### Donations

If you like the work I'm doing maintaining this FOSS friendly version of Telegram, please consider [buying me a beer](https://sinrega.org/?page_id=241).

### Versioning

This repository contains tags to make tracking versions easier.

Versions are in form "v$UPSTREAM$RELEASE" where:

* $UPSTREAM is the public, visible version of upstream.
* $RELEASE is a letter ([a-z]) indicating minor releases between official versions (sometimes, upstream is updated without relating the changes to an specific version).

### API, Protocol documentation

Telegram API manuals: http://core.telegram.org/api

MTproto protocol manuals: http://core.telegram.org/mtproto

### Usage

**Beware of using the dev branch and uploading it to any markets, in many cases it not will work as expected**.

First of all, take a look at **src/main/java/org/telegram/messenger/BuildVars.java** and fill it with correct values.
Import the root folder into your IDE (tested on Android Studio), then run project.

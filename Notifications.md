# Notifications

Since [Android 8.0 Oreo, Google doesn't allow apps to run in the background anymore](https://developer.android.com/about/versions/oreo/background#services), requiring all apps to exclusively use its Firebase push messaging service. 

Since we can't use Google's push messaging with Firebase in our FOSS app, we have three possibilities

 - Do the battery draining general app exclusion (which would be too much and draining more for no good)
 	- *Warning*: if you had to make the exclusion to get notifications for Telegram before, you still may or may not need it. If you didn't, you still don't
 - Lose the ability to receive pushes about new messages altogether (getting pinged once in 15 minutes wouldn't be OK for a messenger, would it?)
 - Show this annoying notification and keep everything as it were.

More than that, if the app would set the notification to lower priority (to hide it a bit in the lower part of the notification screen), you would get the system notification about Telegram "using battery", which is confusing and is the reason for this not being the default. Despite Google's misleading warnings, there is no difference in battery usage between v4.6 in "true background" and v4.9 with notification.

## Make it better

You may still lower the priority of the notification channel or even hide it altogether manually (long tap on the notification). You will receive the misleading system notification then, which [may be disabled as well with another long tap](https://9to5google.com/2017/10/26/how-to-disable-android-oreo-using-battery-notification-android-basics/).

/*
 * This is the source code of Telegram for Android v. 1.3.x.
 * It is licensed under GNU GPL v. 2 or later.
 * You should have received a copy of the license in this archive (see LICENSE).
 *
 * Copyright Nikolai Kudashov, 2013-2017.
 */

package org.telegram.messenger;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.IBinder;
import android.net.Uri;
import android.support.v4.app.NotificationCompat;

public class NotificationsService extends Service {

    @Override
    public void onCreate() {
        ApplicationLoader.postInitApplication();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            String CHANNEL_ID = "push_service_channel";
            NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID,"Push Notifications Service",NotificationManager.IMPORTANCE_DEFAULT);
            notificationManager.createNotificationChannel(channel);
            Intent explainIntent = new Intent("android.intent.action.VIEW");
            explainIntent.setData(Uri.parse("https://github.com/Telegram-FOSS-Team/Telegram-FOSS/blob/master/Notifications.md"));
            PendingIntent explainPendingIntent = PendingIntent.getActivity(this, 0, explainIntent, 0);
            Notification notification = new NotificationCompat.Builder(this, CHANNEL_ID)
                    .setContentIntent(explainPendingIntent)
                    .setSmallIcon(R.drawable.notification)
                    .setContentTitle("Push Notifications")
                    .setContentText("Learn more about this").build();
            startForeground(9999,notification);
        }
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return START_STICKY;
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    public void onDestroy() {
        // Telegram-FOSS: unconditionally enable push service
        Intent intent = new Intent("org.telegram.start");
        sendBroadcast(intent);
    }
}

package org.telegram.messenger;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.PowerManager;

public class NetworkAlarm extends BroadcastReceiver {
    private static PowerManager pm;
    private static PowerManager.WakeLock wl;

    @Override
    public void onReceive(Context context, Intent intent)
    {
        FileLog.d("tmessages", "NetworkAlarm:onReceive, acquiring lock");
        if (wl == null) {
            FileLog.d("tmessages", "NetworkAlarm:onReceive lock is null");
        } else {
            if (!wl.isHeld()) {
                wl.acquire();
                FileLog.d("tmessages", "NetworkAlarm:onReceive lock acquired");
            } else {
                FileLog.d("tmessages", "NetworkAlarm:onReceive lock already held");
            }
        }
    }

    public void setAlarm(Context context, int timeout)
    {
        FileLog.d("tmessages", "NetworkAlarm:setAlarm entry");

        if (pm == null) {
            pm = (PowerManager) context.getSystemService(Context.POWER_SERVICE);
        }

        if (wl == null) {
            wl = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "");
        }

        if (!wl.isHeld()) {
            wl.acquire();
        }

        AlarmManager am =( AlarmManager)context.getSystemService(Context.ALARM_SERVICE);
        Intent i = new Intent(context, NetworkAlarm.class);
        PendingIntent pi = PendingIntent.getBroadcast(context, 0, i, 0);

        am.cancel(pi);
        if (android.os.Build.VERSION.SDK_INT >= 19) {
            am.setExact(AlarmManager.RTC_WAKEUP, System.currentTimeMillis() + timeout, pi);
        } else {
            am.set(AlarmManager.RTC_WAKEUP, System.currentTimeMillis() + timeout, pi);
        }

        FileLog.d("tmessages", "NetworkAlarm:setAlarm exit");
        wl.release();
    }
}

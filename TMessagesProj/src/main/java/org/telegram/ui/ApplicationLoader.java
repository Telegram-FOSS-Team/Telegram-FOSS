/*
 * This is the source code of Telegram for Android v. 1.3.2.
 * It is licensed under GNU GPL v. 2 or later.
 * You should have received a copy of the license in this archive (see LICENSE).
 *
 * Copyright Nikolai Kudashov, 2013.
 */

package org.telegram.ui;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.os.Handler;
import android.view.ViewConfiguration;

import org.telegram.messenger.BackgroundService;
import org.telegram.messenger.ConnectionsManager;
import org.telegram.messenger.FileLog;
import org.telegram.messenger.MessagesController;
import org.telegram.messenger.MessagesStorage;
import org.telegram.messenger.UserConfig;
import org.telegram.messenger.Utilities;
import org.telegram.ui.Views.BaseFragment;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Locale;

public class ApplicationLoader extends Application {
    public static long lastPauseTime;
    public static Bitmap cachedWallpaper = null;
    public static Context applicationContext;
    private Locale currentLocale;

    public static ApplicationLoader Instance = null;

    public static ArrayList<BaseFragment> fragmentsStack = new ArrayList<BaseFragment>();

    @Override
    public void onCreate() {
        super.onCreate();

        currentLocale = Locale.getDefault();
        Instance = this;

        java.lang.System.setProperty("java.net.preferIPv4Stack", "true");
        java.lang.System.setProperty("java.net.preferIPv6Addresses", "false");

        applicationContext = getApplicationContext();
        Utilities.applicationHandler = new Handler(applicationContext.getMainLooper());

        UserConfig.loadConfig();
        if (UserConfig.currentUser != null) {
            SharedPreferences preferences = getSharedPreferences("Notifications", MODE_PRIVATE);
            int v = preferences.getInt("v", 0);
            if (v != 1) {
                SharedPreferences preferences2 = ApplicationLoader.applicationContext.getSharedPreferences("mainconfig", Activity.MODE_PRIVATE);
                SharedPreferences.Editor editor = preferences2.edit();
                if (preferences.contains("view_animations")) {
                    editor.putBoolean("view_animations", preferences.getBoolean("view_animations", false));
                }
                if (preferences.contains("selectedBackground")) {
                    editor.putInt("selectedBackground", preferences.getInt("selectedBackground", 1000001));
                }
                if (preferences.contains("selectedColor")) {
                    editor.putInt("selectedColor", preferences.getInt("selectedColor", 0));
                }
                if (preferences.contains("fons_size")) {
                    editor.putInt("fons_size", preferences.getInt("fons_size", 16));
                }
                editor.commit();
                editor = preferences.edit();
                editor.putInt("v", 1);
                editor.remove("view_animations");
                editor.remove("selectedBackground");
                editor.remove("selectedColor");
                editor.remove("fons_size");
                editor.commit();
            }
            MessagesStorage init = MessagesStorage.Instance;
            MessagesController.Instance.users.put(UserConfig.clientUserId, UserConfig.currentUser);
        }

        try {
            ViewConfiguration config = ViewConfiguration.get(this);
            Field menuKeyField = ViewConfiguration.class.getDeclaredField("sHasPermanentMenuKey");
            if(menuKeyField != null) {
                menuKeyField.setAccessible(true);
                menuKeyField.setBoolean(config, false);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        FileLog.d("tmessages", "This version doesn't support Google Play Services");

        lastPauseTime = System.currentTimeMillis();
        FileLog.e("tmessages", "start application with time " + lastPauseTime);
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        Locale newLocale = newConfig.locale;
        if (newLocale != null) {
            String d1 = newLocale.getDisplayName();
            String d2 = currentLocale.getDisplayName();
            if (d1 != null && d2 != null && !d1.equals(d2)) {
                Utilities.recreateFormatters();
            }
            currentLocale = newLocale;
        }
        Utilities.checkDisplaySize();
    }

    public static void resetLastPauseTime() {
        lastPauseTime = 0;
        ConnectionsManager.Instance.applicationMovedToForeground();
    }

    public static int getAppVersion() {
        try {
            PackageInfo packageInfo = applicationContext.getPackageManager().getPackageInfo(applicationContext.getPackageName(), 0);
            return packageInfo.versionCode;
        } catch (PackageManager.NameNotFoundException e) {
            throw new RuntimeException("Could not get package name: " + e);
        }
    }
}

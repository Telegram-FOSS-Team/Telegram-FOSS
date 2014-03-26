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
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.os.Handler;
import android.view.ViewConfiguration;

import org.telegram.messenger.BackgroundService;
import org.telegram.messenger.BuildVars;
import org.telegram.messenger.ConnectionsManager;
import org.telegram.messenger.FileLog;
import org.telegram.messenger.LocaleController;
import org.telegram.messenger.MessagesController;
import org.telegram.messenger.NativeLoader;
import org.telegram.messenger.ScreenReceiver;
import org.telegram.messenger.UserConfig;
import org.telegram.messenger.Utilities;
import org.telegram.ui.Views.BaseFragment;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.concurrent.atomic.AtomicInteger;

public class ApplicationLoader extends Application {
    public static long lastPauseTime;
    public static Bitmap cachedWallpaper = null;

    public static volatile Context applicationContext = null;
    public static volatile Handler applicationHandler = null;
    private static volatile boolean applicationInited = false;

    public static ArrayList<BaseFragment> fragmentsStack = new ArrayList<BaseFragment>();

    public static void postInitApplication() {
        if (applicationInited) {
            return;
        }
        applicationInited = true;

        NativeLoader.initNativeLibs(applicationContext);

        try {
            final IntentFilter filter = new IntentFilter(Intent.ACTION_SCREEN_ON);
            filter.addAction(Intent.ACTION_SCREEN_OFF);
            final BroadcastReceiver mReceiver = new ScreenReceiver();
            applicationContext.registerReceiver(mReceiver, filter);
        } catch (Exception e) {
            e.printStackTrace();
        }

        UserConfig.loadConfig();
        if (UserConfig.currentUser != null) {
            boolean changed = false;
            SharedPreferences preferences = applicationContext.getSharedPreferences("Notifications", MODE_PRIVATE);
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

            MessagesController.getInstance().users.put(UserConfig.clientUserId, UserConfig.currentUser);
            ConnectionsManager.getInstance().applyCountryPortNumber(UserConfig.currentUser.phone);
        }

        ApplicationLoader app = (ApplicationLoader)ApplicationLoader.applicationContext;
        app.initPlayServices();
    }

    @Override
    public void onCreate() {
        super.onCreate();
        lastPauseTime = System.currentTimeMillis();
        applicationContext = getApplicationContext();
        NativeLoader.initNativeLibs(this);
        try {
            LocaleController.getInstance();
        } catch (Exception e) {
            e.printStackTrace();
        }

        applicationHandler = new Handler(applicationContext.getMainLooper());

        java.lang.System.setProperty("java.net.preferIPv4Stack", "true");
        java.lang.System.setProperty("java.net.preferIPv6Addresses", "false");

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
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        try {
            LocaleController.getInstance().onDeviceConfigurationChange(newConfig);
            Utilities.checkDisplaySize();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void resetLastPauseTime() {
        lastPauseTime = 0;
        ConnectionsManager.getInstance().applicationMovedToForeground();
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

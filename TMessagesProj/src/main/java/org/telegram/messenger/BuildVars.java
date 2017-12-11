/*
 * This is the source code of Telegram for Android v. 4.x.x.
 * It is licensed under GNU GPL v. 2 or later.
 * You should have received a copy of the license in this archive (see LICENSE).
 *
 * Copyright Nikolai Kudashov, 2013-2017.
 */

package org.telegram.messenger;

public class BuildVars {
    public static boolean DEBUG_VERSION = BuildConfig.DEBUG;
    public static boolean DEBUG_PRIVATE_VERSION = false;
    public static int BUILD_VERSION = 1156;
    public static String BUILD_VERSION_STRING = "4.6";
    public static int APP_ID = BuildConfig.APP_ID; //obtain your own APP_ID at https://core.telegram.org/api/obtaining_api_id
    public static String APP_HASH = BuildConfig.APP_HASH; //obtain your own APP_HASH at https://core.telegram.org/api/obtaining_api_id
    public static String GOOGLE_API_KEY = "";
}

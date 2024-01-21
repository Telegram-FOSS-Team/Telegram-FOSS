package org.telegram.messenger;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.text.TextUtils;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.util.Consumer;
import androidx.core.util.Pair;


import com.google.android.exoplayer2.util.Util;

import org.telegram.messenger.utils.BillingUtilities;
import org.telegram.tgnet.ConnectionsManager;
import org.telegram.tgnet.TLRPC;
import org.telegram.ui.ActionBar.AlertDialog;
import org.telegram.ui.PremiumPreviewFragment;
import org.telegram.ui.Stars.StarsController;

import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Currency;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

public class BillingController {
    public final static String PREMIUM_PRODUCT_ID = "telegram_premium";

    private static BillingController instance;

    public static boolean billingClientEmpty;

    private final List<String> requestingTokens = Collections.synchronizedList(new ArrayList<>());
    private final Map<String, Integer> currencyExpMap = new HashMap<>();

    private String lastPremiumTransaction;
    private String lastPremiumToken;
    private boolean isDisconnected;
    private Runnable onCanceled;

    public static BillingController getInstance() {
        if (instance == null) {
            instance = new BillingController(ApplicationLoader.applicationContext);
        }
        return instance;
    }

    private BillingController(Context ctx) {
    }

    public void setOnCanceled(Runnable onCanceled) {
        this.onCanceled = onCanceled;
    }

    public String getLastPremiumTransaction() {
        return lastPremiumTransaction;
    }

    public String getLastPremiumToken() {
        return lastPremiumToken;
    }

    public String formatCurrency(long amount, String currency) {
        return formatCurrency(amount, currency, getCurrencyExp(currency));
    }

    public String formatCurrency(long amount, String currency, int exp) {
        return formatCurrency(amount, currency, exp, false);
    }

    private static NumberFormat currencyInstance;
    public String formatCurrency(long amount, String currency, int exp, boolean rounded) {
        if (currency == null || currency.isEmpty()) {
            return String.valueOf(amount);
        }
        if ("TON".equalsIgnoreCase(currency)) {
            return "TON " + (amount / 1_000_000_000.0);
        }
        Currency cur = Currency.getInstance(currency);
        if (cur != null) {
            if (currencyInstance == null) {
                currencyInstance = NumberFormat.getCurrencyInstance();
            }
            currencyInstance.setCurrency(cur);
            if (rounded) {
                return currencyInstance.format(Math.round(amount / Math.pow(10, exp)));
            }
            return currencyInstance.format(amount / Math.pow(10, exp));
        }
        return amount + " " + currency;
    }

    @SuppressWarnings("ConstantConditions")
    public int getCurrencyExp(String currency) {
        BillingUtilities.extractCurrencyExp(currencyExpMap);
        return currencyExpMap.getOrDefault(currency, 0);
    }


    private void switchToInvoice() {
        if (billingClientEmpty) {
            return;
        }
        billingClientEmpty = true;
        NotificationCenter.getGlobalInstance().postNotificationName(NotificationCenter.billingProductDetailsUpdated);
    }

    private void switchBackFromInvoice() {
        if (!billingClientEmpty) {
            return;
        }
        billingClientEmpty = false;
        NotificationCenter.getGlobalInstance().postNotificationName(NotificationCenter.billingProductDetailsUpdated);
    }


    public static String getResponseCodeString(int code) {
        switch (code) {
            case -3: return "SERVICE_TIMEOUT";
            case -2: return "FEATURE_NOT_SUPPORTED";
            case -1: return "SERVICE_DISCONNECTED";
            case 0: return "OK";
            case 1: return "USER_CANCELED";
            case 2: return "SERVICE_UNAVAILABLE";
            case 3: return "BILLING_UNAVAILABLE";
            case 4: return "ITEM_UNAVAILABLE";
            case 5: return "DEVELOPER_ERROR";
            case 6: return "ERROR";
            case 7: return "ITEM_ALREADY_OWNED";
            case 8: return "ITEM_NOT_OWNED";
        }
        return null;
    }
}

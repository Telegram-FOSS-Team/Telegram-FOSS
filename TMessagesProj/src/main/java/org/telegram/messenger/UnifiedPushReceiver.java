package org.telegram.messenger;

import android.content.Context;
import android.os.SystemClock;

import androidx.annotation.NonNull;

import org.telegram.tgnet.ConnectionsManager;
import org.unifiedpush.android.connector.MessagingReceiver;

import java.util.concurrent.CountDownLatch;

public class UnifiedPushReceiver extends MessagingReceiver {
    @Override
    public void onNewEndpoint(Context context, String endpoint, String instance){
        Utilities.globalQueue.postRunnable(() -> {
            SharedConfig.pushStringGetTimeEnd = SystemClock.elapsedRealtime();

            PushListenerController.sendRegistrationToServer(PushListenerController.PUSH_TYPE_SIMPLE, endpoint);
        });
    }

    @Override
    public void onMessage(Context context, byte[] message, String instance){
        final long receiveTime = SystemClock.elapsedRealtime();
        final CountDownLatch countDownLatch = new CountDownLatch(1);

        AndroidUtilities.runOnUIThread(() -> {
            if (BuildVars.LOGS_ENABLED) {
                FileLog.d("UP PRE INIT APP");
            }
            ApplicationLoader.postInitApplication();
            if (BuildVars.LOGS_ENABLED) {
                FileLog.d("UP POST INIT APP");
            }
            Utilities.stageQueue.postRunnable(() -> {
                if (BuildVars.LOGS_ENABLED) {
                    FileLog.d("UP START PROCESSING");
                }
                for (int a = 0; a < UserConfig.MAX_ACCOUNT_COUNT; a++) {
                    if (UserConfig.getInstance(a).isClientActivated()) {
                        ConnectionsManager.onInternalPushReceived(a);
                        ConnectionsManager.getInstance(a).resumeNetworkMaybe();
                    }
                }
                countDownLatch.countDown();
            });
        });
        Utilities.globalQueue.postRunnable(()-> {
            try {
                countDownLatch.await();
            } catch (Throwable ignore) {

            }
            if (BuildVars.DEBUG_VERSION) {
                FileLog.d("finished UP service, time = " + (SystemClock.elapsedRealtime() - receiveTime));
            }
        });
    }

    @Override
    public void onRegistrationFailed(Context context, String instance){
        if (BuildVars.LOGS_ENABLED) {
            FileLog.d("Failed to get endpoint");
        }
        SharedConfig.pushStringStatus = "__UNIFIEDPUSH_FAILED__";
        Utilities.globalQueue.postRunnable(() -> {
            SharedConfig.pushStringGetTimeEnd = SystemClock.elapsedRealtime();

            PushListenerController.sendRegistrationToServer(PushListenerController.PUSH_TYPE_SIMPLE, null);
        });
    }

    @Override
    public void onUnregistered(Context context, String instance){
        SharedConfig.pushStringStatus = "__UNIFIEDPUSH_FAILED__";
        Utilities.globalQueue.postRunnable(() -> {
            SharedConfig.pushStringGetTimeEnd = SystemClock.elapsedRealtime();

            PushListenerController.sendRegistrationToServer(PushListenerController.PUSH_TYPE_SIMPLE, null);
        });
    }
}

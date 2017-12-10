/*
 * This is the source code of Telegram for Android v. 3.x.x
 * It is licensed under GNU GPL v. 2 or later.
 * You should have received a copy of the license in this archive (see LICENSE).
 *
 * Copyright Nikolai Kudashov, 2013-2017.
 */

package org.telegram.ui.Adapters;

import android.location.Location;
import android.os.AsyncTask;

import org.json.JSONObject;
import org.telegram.messenger.AndroidUtilities;
import org.telegram.messenger.FileLog;
import org.telegram.tgnet.TLRPC;
import org.telegram.ui.Components.RecyclerListView;

import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;

public abstract class BaseLocationAdapter extends RecyclerListView.SelectionAdapter {

    public interface BaseLocationAdapterDelegate {
        void didLoadedSearchResult(ArrayList<TLRPC.TL_messageMediaVenue> places);
    }

    protected boolean searching;
    protected ArrayList<TLRPC.TL_messageMediaVenue> places = new ArrayList<>();
    protected ArrayList<String> iconUrls = new ArrayList<>();
    private Location lastSearchLocation;
    private BaseLocationAdapterDelegate delegate;
    private Timer searchTimer;
    private AsyncTask<Void, Void, JSONObject> currentTask;

    public void destroy() {
        if (currentTask != null) {
            currentTask.cancel(true);
            currentTask = null;
        }
    }

    public void setDelegate(BaseLocationAdapterDelegate delegate) {
        this.delegate = delegate;
    }

    public void searchDelayed(final String query, final Location coordinate) {
        if (query == null || query.length() == 0) {
            places.clear();
            notifyDataSetChanged();
        } else {
            try {
                if (searchTimer != null) {
                    searchTimer.cancel();
                }
            } catch (Exception e) {
                FileLog.e(e);
            }
            searchTimer = new Timer();
            searchTimer.schedule(new TimerTask() {
                @Override
                public void run() {
                    try {
                        searchTimer.cancel();
                        searchTimer = null;
                    } catch (Exception e) {
                        FileLog.e(e);
                    }
                    AndroidUtilities.runOnUIThread(new Runnable() {
                        @Override
                        public void run() {
                            lastSearchLocation = null;
                            searchGooglePlacesWithQuery(query, coordinate);
                        }
                    });
                }
            }, 200, 500);
        }
    }

    public void searchGooglePlacesWithQuery(final String query, final Location coordinate) {
        searching = false;
        if (delegate != null) {
            delegate.didLoadedSearchResult(places);
        }
        notifyDataSetChanged();
    }
}

/*
 * This is the source code of Telegram for Android v. 3.x.x
 * It is licensed under GNU GPL v. 2 or later.
 * You should have received a copy of the license in this archive (see LICENSE).
 *
 * Copyright Nikolai Kudashov, 2013-2017.
 */

package org.telegram.ui.Adapters;

import android.content.Context;
import android.location.Location;
import android.view.View;
import android.view.ViewGroup;

import org.telegram.messenger.LocaleController;
import org.telegram.messenger.R;
import org.telegram.messenger.support.widget.RecyclerView;
import org.telegram.tgnet.TLRPC;
import org.telegram.ui.Cells.EmptyCell;
import org.telegram.ui.Cells.SendLocationCell;
import org.telegram.ui.Components.RecyclerListView;

import java.util.Locale;

public class LocationActivityAdapter extends BaseLocationAdapter {

    private Context mContext;
    private int overScrollHeight;
    private SendLocationCell sendLocationCell;
    private Location gpsLocation;
    private Location customLocation;

    public LocationActivityAdapter(Context context) {
        super();
        mContext = context;
    }

    public void setOverScrollHeight(int value) {
        overScrollHeight = value;
    }

    public void setGpsLocation(Location location) {
        gpsLocation = location;
        updateCell();
    }

    public void setCustomLocation(Location location) {
        customLocation = location;
        updateCell();
    }

    private void updateCell() {
        if (sendLocationCell != null) {
            if (customLocation != null) {
                sendLocationCell.setText(LocaleController.getString("SendSelectedLocation", R.string.SendSelectedLocation), String.format(Locale.US, "(%f,%f)", customLocation.getLatitude(), customLocation.getLongitude()));
            } else {
                if (gpsLocation != null) {
                    sendLocationCell.setText(LocaleController.getString("SendLocation", R.string.SendLocation), LocaleController.formatString("AccurateTo", R.string.AccurateTo, LocaleController.formatPluralString("Meters", (int) gpsLocation.getAccuracy())));
                } else {
                    sendLocationCell.setText(LocaleController.getString("SendLocation", R.string.SendLocation), LocaleController.getString("Loading", R.string.Loading));
                }
            }
        }
    }

    @Override
    public int getItemCount() {
            return 2;
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view;
        switch (viewType) {
            case 0:
                view = new EmptyCell(mContext);
                break;
            case 1:
                view = new SendLocationCell(mContext);
                break;
            default:
                view = new EmptyCell(mContext);
                break;
        }
        return new RecyclerListView.Holder(view);
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        switch (holder.getItemViewType()) {
            case 0:
                ((EmptyCell) holder.itemView).setHeight(overScrollHeight);
                break;
            case 1:
                sendLocationCell = (SendLocationCell) holder.itemView;
                updateCell();
                break;
        }
    }

    public TLRPC.TL_messageMediaVenue getItem(int i) {
        if (i > 2 && i < places.size() + 3) {
            return places.get(i - 3);
        }
        return null;
    }

    @Override
    public int getItemViewType(int position) {
        return position;
    }

    @Override
    public boolean isEnabled(RecyclerView.ViewHolder holder) {
        int position = holder.getAdapterPosition();
        return !(position == 2 || position == 0);
    }
}

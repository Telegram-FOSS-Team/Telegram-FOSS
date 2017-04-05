/*
 * This is the source code of Telegram for Android v. 3.x.x.
 * It is licensed under GNU GPL v. 2 or later.
 * You should have received a copy of the license in this archive (see LICENSE).
 *
 * Copyright Nikolai Kudashov, 2013-2017.
 */

package org.telegram.ui;

import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.graphics.Rect;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.view.Gravity;
import android.view.Surface;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.FrameLayout;

import org.json.JSONArray;
import org.json.JSONObject;
import org.telegram.messenger.AndroidUtilities;
import org.telegram.messenger.BuildVars;
import org.telegram.messenger.FileLoader;
import org.telegram.messenger.LocaleController;
import org.telegram.messenger.MediaController;
import org.telegram.messenger.MessagesStorage;
import org.telegram.messenger.NotificationCenter;
import org.telegram.messenger.Utilities;
import org.telegram.messenger.VideoEditedInfo;
import org.telegram.messenger.ApplicationLoader;
import org.telegram.messenger.FileLog;
import org.telegram.messenger.R;
import org.telegram.messenger.support.widget.GridLayoutManager;
import org.telegram.messenger.support.widget.RecyclerView;
import org.telegram.tgnet.ConnectionsManager;
import org.telegram.tgnet.RequestDelegate;
import org.telegram.tgnet.TLObject;
import org.telegram.tgnet.TLRPC;
import org.telegram.messenger.MessageObject;
import org.telegram.messenger.UserConfig;
import org.telegram.ui.ActionBar.ActionBarMenu;
import org.telegram.ui.ActionBar.ActionBarMenuItem;
import org.telegram.ui.ActionBar.AlertDialog;
import org.telegram.ui.ActionBar.Theme;
import org.telegram.ui.ActionBar.ActionBar;
import org.telegram.ui.ActionBar.BaseFragment;
import org.telegram.ui.Cells.PhotoPickerPhotoCell;
import org.telegram.ui.Components.BackupImageView;
import org.telegram.ui.Components.EmptyTextProgressView;
import org.telegram.ui.Components.LayoutHelper;
import org.telegram.ui.Components.PickerBottomLayout;
import org.telegram.ui.Components.RadialProgressView;
import org.telegram.ui.Components.RecyclerListView;

import java.io.FileNotFoundException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.SocketException;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Locale;

public class PhotoPickerActivity extends BaseFragment implements NotificationCenter.NotificationCenterDelegate, PhotoViewer.PhotoViewerProvider {

    public interface PhotoPickerActivityDelegate {
        void selectedPhotosChanged();

        void actionButtonPressed(boolean canceled);

        void didSelectVideo(String path, VideoEditedInfo info, long estimatedSize, long estimatedDuration, String caption);
    }

    private int type;
    private HashMap<String, MediaController.SearchImage> selectedWebPhotos;
    private HashMap<Integer, MediaController.PhotoEntry> selectedPhotos;
    private ArrayList<MediaController.SearchImage> recentImages;

    private ArrayList<MediaController.SearchImage> searchResult = new ArrayList<>();
    private HashMap<String, MediaController.SearchImage> searchResultKeys = new HashMap<>();
    private HashMap<String, MediaController.SearchImage> searchResultUrls = new HashMap<>();

    private boolean searching;
    private boolean bingSearchEndReached = true;
    private boolean giphySearchEndReached = true;
    private String lastSearchString;
    private boolean loadingRecent;
    private int nextGiphySearchOffset;
    private int giphyReqId;
    private int lastSearchToken;
    private boolean allowCaption = true;
    private AsyncTask<Void, Void, JSONObject> currentBingTask;

    private MediaController.AlbumEntry selectedAlbum;

    private RecyclerListView listView;
    private ListAdapter listAdapter;
    private GridLayoutManager layoutManager;
    private PickerBottomLayout pickerBottomLayout;
    private EmptyTextProgressView emptyView;
    private ActionBarMenuItem searchItem;
    private int itemWidth = 100;
    private boolean sendPressed;
    private boolean singlePhoto;
    private ChatActivity chatActivity;

    private PhotoPickerActivityDelegate delegate;

    public PhotoPickerActivity(int type, MediaController.AlbumEntry selectedAlbum, HashMap<Integer, MediaController.PhotoEntry> selectedPhotos, HashMap<String, MediaController.SearchImage> selectedWebPhotos, ArrayList<MediaController.SearchImage> recentImages, boolean onlyOnePhoto, boolean allowCaption, ChatActivity chatActivity) {
        super();
        this.selectedAlbum = selectedAlbum;
        this.selectedPhotos = selectedPhotos;
        this.selectedWebPhotos = selectedWebPhotos;
        this.type = type;
        this.recentImages = recentImages;
        this.singlePhoto = onlyOnePhoto;
        this.chatActivity = chatActivity;
        this.allowCaption = allowCaption;
        if (selectedAlbum != null && selectedAlbum.isVideo) {
            singlePhoto = true;
        }
    }

    @Override
    public boolean onFragmentCreate() {
        NotificationCenter.getInstance().addObserver(this, NotificationCenter.closeChats);
        NotificationCenter.getInstance().addObserver(this, NotificationCenter.recentImagesDidLoaded);
        if (selectedAlbum == null) {
            if (recentImages.isEmpty()) {
                MessagesStorage.getInstance().loadWebRecent(type);
                loadingRecent = true;
            }
        }
        return super.onFragmentCreate();
    }

    @Override
    public void onFragmentDestroy() {
        NotificationCenter.getInstance().removeObserver(this, NotificationCenter.closeChats);
        NotificationCenter.getInstance().removeObserver(this, NotificationCenter.recentImagesDidLoaded);
        if (currentBingTask != null) {
            currentBingTask.cancel(true);
            currentBingTask = null;
        }
        if (giphyReqId != 0) {
            ConnectionsManager.getInstance().cancelRequest(giphyReqId, true);
            giphyReqId = 0;
        }
        super.onFragmentDestroy();
    }

    @SuppressWarnings("unchecked")
    @Override
    public View createView(Context context) {
        actionBar.setBackgroundColor(Theme.ACTION_BAR_MEDIA_PICKER_COLOR);
        actionBar.setItemsBackgroundColor(Theme.ACTION_BAR_PICKER_SELECTOR_COLOR, false);
        actionBar.setTitleColor(0xffffffff);
        actionBar.setBackButtonImage(R.drawable.ic_ab_back);
        if (selectedAlbum != null) {
            actionBar.setTitle(selectedAlbum.bucketName);
        } else if (type == 0) {
            actionBar.setTitle(LocaleController.getString("SearchImagesTitle", R.string.SearchImagesTitle));
        } else if (type == 1) {
            actionBar.setTitle(LocaleController.getString("SearchGifsTitle", R.string.SearchGifsTitle));
        }
        actionBar.setActionBarMenuOnItemClick(new ActionBar.ActionBarMenuOnItemClick() {
            @Override
            public void onItemClick(int id) {
                if (id == -1) {
                    finishFragment();
                }
            }
        });

        if (selectedAlbum == null) {
            ActionBarMenu menu = actionBar.createMenu();
            searchItem = menu.addItem(0, R.drawable.ic_ab_search).setIsSearchField(true).setActionBarMenuItemSearchListener(new ActionBarMenuItem.ActionBarMenuItemSearchListener() {
                @Override
                public void onSearchExpand() {

                }

                @Override
                public boolean canCollapseSearch() {
                    finishFragment();
                    return false;
                }

                @Override
                public void onTextChanged(EditText editText) {
                    if (editText.getText().length() == 0) {
                        searchResult.clear();
                        searchResultKeys.clear();
                        lastSearchString = null;
                        bingSearchEndReached = true;
                        giphySearchEndReached = true;
                        searching = false;
                        if (currentBingTask != null) {
                            currentBingTask.cancel(true);
                            currentBingTask = null;
                        }
                        if (giphyReqId != 0) {
                            ConnectionsManager.getInstance().cancelRequest(giphyReqId, true);
                            giphyReqId = 0;
                        }
                        if (type == 0) {
                            emptyView.setText(LocaleController.getString("NoRecentPhotos", R.string.NoRecentPhotos));
                        } else if (type == 1) {
                            emptyView.setText(LocaleController.getString("NoRecentGIFs", R.string.NoRecentGIFs));
                        }
                        updateSearchInterface();
                    }
                }

                @Override
                public void onSearchPressed(EditText editText) {
                    // Telegram-FOSS doesn't support searching with external engines (privacy issues)
                    return;
                }
            });
        }

        if (selectedAlbum == null) {
            if (type == 0) {
                searchItem.getSearchField().setHint(LocaleController.getString("SearchImagesTitle", R.string.SearchImagesTitle));
            } else if (type == 1) {
                searchItem.getSearchField().setHint(LocaleController.getString("SearchGifsTitle", R.string.SearchGifsTitle));
            }
        }

        fragmentView = new FrameLayout(context);

        FrameLayout frameLayout = (FrameLayout) fragmentView;
        frameLayout.setBackgroundColor(0xff000000);

        listView = new RecyclerListView(context);
        listView.setPadding(AndroidUtilities.dp(4), AndroidUtilities.dp(4), AndroidUtilities.dp(4), AndroidUtilities.dp(4));
        listView.setClipToPadding(false);
        listView.setHorizontalScrollBarEnabled(false);
        listView.setVerticalScrollBarEnabled(false);
        listView.setItemAnimator(null);
        listView.setLayoutAnimation(null);
        listView.setLayoutManager(layoutManager = new GridLayoutManager(context, 4) {
            @Override
            public boolean supportsPredictiveItemAnimations() {
                return false;
            }
        });
        listView.addItemDecoration(new RecyclerView.ItemDecoration() {
            @Override
            public void getItemOffsets(Rect outRect, View view, RecyclerView parent, RecyclerView.State state) {
                super.getItemOffsets(outRect, view, parent, state);
                int total = state.getItemCount();
                int position = parent.getChildAdapterPosition(view);
                int spanCount = layoutManager.getSpanCount();
                int rowsCOunt = (int) Math.ceil(total / (float) spanCount);
                int row = position / spanCount;
                int col = position % spanCount;
                outRect.right = col != spanCount - 1 ? AndroidUtilities.dp(4) : 0;
                outRect.bottom = row != rowsCOunt - 1 ? AndroidUtilities.dp(4) : 0;
            }
        });
        frameLayout.addView(listView, LayoutHelper.createFrame(LayoutHelper.MATCH_PARENT, LayoutHelper.MATCH_PARENT, Gravity.LEFT | Gravity.TOP, 0, 0, 0, singlePhoto ? 0 : 48));
        listView.setAdapter(listAdapter = new ListAdapter(context));
        listView.setGlowColor(0xff333333);
        listView.setOnItemClickListener(new RecyclerListView.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                if (selectedAlbum != null && selectedAlbum.isVideo) {
                    if (position < 0 || position >= selectedAlbum.photos.size()) {
                        return;
                    }

                    String path = selectedAlbum.photos.get(position).path;
                    if (Build.VERSION.SDK_INT >= 16) {
                        Bundle args = new Bundle();
                        args.putString("videoPath", path);
                        VideoEditorActivity fragment = new VideoEditorActivity(args);
                        fragment.setDelegate(new VideoEditorActivity.VideoEditorActivityDelegate() {
                            @Override
                            public void didFinishEditVideo(String videoPath, long startTime, long endTime, int resultWidth, int resultHeight, int rotationValue, int originalWidth, int originalHeight, int bitrate, long estimatedSize, long estimatedDuration, String caption) {
                                removeSelfFromStack();
                                VideoEditedInfo videoEditedInfo = new VideoEditedInfo();
                                videoEditedInfo.startTime = startTime;
                                videoEditedInfo.endTime = endTime;
                                videoEditedInfo.rotationValue = rotationValue;
                                videoEditedInfo.originalWidth = originalWidth;
                                videoEditedInfo.originalHeight = originalHeight;
                                videoEditedInfo.bitrate = bitrate;
                                videoEditedInfo.resultWidth = resultWidth;
                                videoEditedInfo.resultHeight = resultHeight;
                                videoEditedInfo.originalPath = videoPath;
                                delegate.didSelectVideo(videoPath, videoEditedInfo, estimatedSize, estimatedDuration, caption);
                            }
                        });

                        if (!fragment.onFragmentCreate()) {
                            delegate.didSelectVideo(path, null, 0, 0, null);
                            finishFragment();
                        } else if (parentLayout.presentFragment(fragment, false, false, true)) {
                            fragment.setParentChatActivity(chatActivity);
                        }
                    } else {
                        delegate.didSelectVideo(path, null, 0, 0, null);
                        finishFragment();
                    }
                } else {
                    ArrayList<Object> arrayList;
                    if (selectedAlbum != null) {
                        arrayList = (ArrayList) selectedAlbum.photos;
                    } else {
                        if (searchResult.isEmpty() && lastSearchString == null) {
                            arrayList = (ArrayList) recentImages;
                        } else {
                            arrayList = (ArrayList) searchResult;
                        }
                    }
                    if (position < 0 || position >= arrayList.size()) {
                        return;
                    }
                    if (searchItem != null) {
                        AndroidUtilities.hideKeyboard(searchItem.getSearchField());
                    }
                    PhotoViewer.getInstance().setParentActivity(getParentActivity());
                    PhotoViewer.getInstance().openPhotoForSelect(arrayList, position, singlePhoto ? 1 : 0, PhotoPickerActivity.this, chatActivity);
                }
            }
        });

        if (selectedAlbum == null) {
            listView.setOnItemLongClickListener(new RecyclerListView.OnItemLongClickListener() {
                @Override
                public boolean onItemClick(View view, int position) {
					// Telegram-FOSS doesn't support searching with external engines (privacy issues)
                    return false;
                }
            });
        }

        emptyView = new EmptyTextProgressView(context);
        emptyView.setTextColor(0xff808080);
        emptyView.setProgressBarColor(0xffffffff);
        emptyView.setShowAtCenter(true);
        if (selectedAlbum != null) {
            emptyView.setText(LocaleController.getString("NoPhotos", R.string.NoPhotos));
        } else {
            if (type == 0) {
                emptyView.setText(LocaleController.getString("NoRecentPhotos", R.string.NoRecentPhotos));
            } else if (type == 1) {
                emptyView.setText(LocaleController.getString("NoRecentGIFs", R.string.NoRecentGIFs));
            }
        }
        frameLayout.addView(emptyView, LayoutHelper.createFrame(LayoutHelper.MATCH_PARENT, LayoutHelper.MATCH_PARENT, Gravity.LEFT | Gravity.TOP, 0, 0, 0, singlePhoto ? 0 : 48));

        if (selectedAlbum == null) {
            listView.setOnScrollListener(new RecyclerView.OnScrollListener() {
                @Override
                public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
                    if (newState == RecyclerView.SCROLL_STATE_DRAGGING) {
                        AndroidUtilities.hideKeyboard(getParentActivity().getCurrentFocus());
                    }
                }

                @Override
                public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
				// Telegram-FOSS doesn't support searching with external engines (privacy issues)
                }
            });

            updateSearchInterface();
        }

        pickerBottomLayout = new PickerBottomLayout(context);
        frameLayout.addView(pickerBottomLayout, LayoutHelper.createFrame(LayoutHelper.MATCH_PARENT, 48, Gravity.BOTTOM));
        pickerBottomLayout.cancelButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                delegate.actionButtonPressed(true);
                finishFragment();
            }
        });
        pickerBottomLayout.doneButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                sendSelectedPhotos();
            }
        });
        if (singlePhoto) {
            pickerBottomLayout.setVisibility(View.GONE);
        }

        listView.setEmptyView(emptyView);
        pickerBottomLayout.updateSelectedCount(selectedPhotos.size() + selectedWebPhotos.size(), true);

        return fragmentView;
    }

    @Override
    public void onResume() {
        super.onResume();
        if (listAdapter != null) {
            listAdapter.notifyDataSetChanged();
        }
        if (searchItem != null) {
            searchItem.openSearch(true);
            getParentActivity().getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN);
        }
        fixLayout();
    }

    @Override
    public void onConfigurationChanged(android.content.res.Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        fixLayout();
    }

    @SuppressWarnings("unchecked")
    @Override
    public void didReceivedNotification(int id, Object... args) {
        if (id == NotificationCenter.closeChats) {
            removeSelfFromStack();
        } else if (id == NotificationCenter.recentImagesDidLoaded) {
            if (selectedAlbum == null && type == (Integer) args[0]) {
                recentImages = (ArrayList<MediaController.SearchImage>) args[1];
                loadingRecent = false;
                updateSearchInterface();
            }
        }
    }

    private PhotoPickerPhotoCell getCellForIndex(int index) {
        int count = listView.getChildCount();

        for (int a = 0; a < count; a++) {
            View view = listView.getChildAt(a);
            if (view instanceof PhotoPickerPhotoCell) {
                PhotoPickerPhotoCell cell = (PhotoPickerPhotoCell) view;
                int num = (Integer) cell.photoImage.getTag();
                if (selectedAlbum != null) {
                    if (num < 0 || num >= selectedAlbum.photos.size()) {
                        continue;
                    }
                } else {
                    ArrayList<MediaController.SearchImage> array;
                    if (searchResult.isEmpty() && lastSearchString == null) {
                        array = recentImages;
                    } else {
                        array = searchResult;
                    }
                    if (num < 0 || num >= array.size()) {
                        continue;
                    }
                }
                if (num == index) {
                    return cell;
                }
            }
        }
        return null;
    }

    @Override
    public boolean scaleToFill() {
        return false;
    }

    @Override
    public PhotoViewer.PlaceProviderObject getPlaceForPhoto(MessageObject messageObject, TLRPC.FileLocation fileLocation, int index) {
        PhotoPickerPhotoCell cell = getCellForIndex(index);
        if (cell != null) {
            int coords[] = new int[2];
            cell.photoImage.getLocationInWindow(coords);
            PhotoViewer.PlaceProviderObject object = new PhotoViewer.PlaceProviderObject();
            object.viewX = coords[0];
            object.viewY = coords[1] - (Build.VERSION.SDK_INT >= 21 ? 0 : AndroidUtilities.statusBarHeight);
            object.parentView = listView;
            object.imageReceiver = cell.photoImage.getImageReceiver();
            object.thumb = object.imageReceiver.getBitmap();
            object.scale = cell.photoImage.getScaleX();
            cell.checkBox.setVisibility(View.GONE);
            return object;
        }
        return null;
    }

    @Override
    public void updatePhotoAtIndex(int index) {
        PhotoPickerPhotoCell cell = getCellForIndex(index);
        if (cell != null) {
            if (selectedAlbum != null) {
                cell.photoImage.setOrientation(0, true);
                MediaController.PhotoEntry photoEntry = selectedAlbum.photos.get(index);
                if (photoEntry.thumbPath != null) {
                    cell.photoImage.setImage(photoEntry.thumbPath, null, cell.getContext().getResources().getDrawable(R.drawable.nophotos));
                } else if (photoEntry.path != null) {
                    cell.photoImage.setOrientation(photoEntry.orientation, true);
                    if (photoEntry.isVideo) {
                        cell.photoImage.setImage("vthumb://" + photoEntry.imageId + ":" + photoEntry.path, null, cell.getContext().getResources().getDrawable(R.drawable.nophotos));
                    } else {
                        cell.photoImage.setImage("thumb://" + photoEntry.imageId + ":" + photoEntry.path, null, cell.getContext().getResources().getDrawable(R.drawable.nophotos));
                    }
                } else {
                    cell.photoImage.setImageResource(R.drawable.nophotos);
                }
            } else {
                ArrayList<MediaController.SearchImage> array;
                if (searchResult.isEmpty() && lastSearchString == null) {
                    array = recentImages;
                } else {
                    array = searchResult;
                }
                MediaController.SearchImage photoEntry = array.get(index);
                if (photoEntry.document != null && photoEntry.document.thumb != null) {
                    cell.photoImage.setImage(photoEntry.document.thumb.location, null, cell.getContext().getResources().getDrawable(R.drawable.nophotos));
                } else if (photoEntry.thumbPath != null) {
                    cell.photoImage.setImage(photoEntry.thumbPath, null, cell.getContext().getResources().getDrawable(R.drawable.nophotos));
                } else if (photoEntry.thumbUrl != null && photoEntry.thumbUrl.length() > 0) {
                    cell.photoImage.setImage(photoEntry.thumbUrl, null, cell.getContext().getResources().getDrawable(R.drawable.nophotos));
                } else {
                    cell.photoImage.setImageResource(R.drawable.nophotos);
                }
            }
        }
    }

    @Override
    public boolean allowCaption() {
        return allowCaption;
    }

    @Override
    public Bitmap getThumbForPhoto(MessageObject messageObject, TLRPC.FileLocation fileLocation, int index) {
        PhotoPickerPhotoCell cell = getCellForIndex(index);
        if (cell != null) {
            return cell.photoImage.getImageReceiver().getBitmap();
        }
        return null;
    }

    @Override
    public void willSwitchFromPhoto(MessageObject messageObject, TLRPC.FileLocation fileLocation, int index) {
        int count = listView.getChildCount();
        for (int a = 0; a < count; a++) {
            View view = listView.getChildAt(a);
            if (view.getTag() == null) {
                continue;
            }
            PhotoPickerPhotoCell cell = (PhotoPickerPhotoCell) view;
            int num = (Integer) view.getTag();
            if (selectedAlbum != null) {
                if (num < 0 || num >= selectedAlbum.photos.size()) {
                    continue;
                }
            } else {
                ArrayList<MediaController.SearchImage> array;
                if (searchResult.isEmpty() && lastSearchString == null) {
                    array = recentImages;
                } else {
                    array = searchResult;
                }
                if (num < 0 || num >= array.size()) {
                    continue;
                }
            }
            if (num == index) {
                cell.checkBox.setVisibility(View.VISIBLE);
                break;
            }
        }
    }

    @Override
    public void willHidePhotoViewer() {
        int count = listView.getChildCount();
        for (int a = 0; a < count; a++) {
            View view = listView.getChildAt(a);
            if (view instanceof PhotoPickerPhotoCell) {
                PhotoPickerPhotoCell cell = (PhotoPickerPhotoCell) view;
                if (cell.checkBox.getVisibility() != View.VISIBLE) {
                    cell.checkBox.setVisibility(View.VISIBLE);
                }
            }
        }
    }

    @Override
    public boolean isPhotoChecked(int index) {
        if (selectedAlbum != null) {
            return !(index < 0 || index >= selectedAlbum.photos.size()) && selectedPhotos.containsKey(selectedAlbum.photos.get(index).imageId);
        } else {
            ArrayList<MediaController.SearchImage> array;
            if (searchResult.isEmpty() && lastSearchString == null) {
                array = recentImages;
            } else {
                array = searchResult;
            }
            return !(index < 0 || index >= array.size()) && selectedWebPhotos.containsKey(array.get(index).id);
        }
    }

    @Override
    public void setPhotoChecked(int index) {
        boolean add = true;
        if (selectedAlbum != null) {
            if (index < 0 || index >= selectedAlbum.photos.size()) {
                return;
            }
            MediaController.PhotoEntry photoEntry = selectedAlbum.photos.get(index);
            if (selectedPhotos.containsKey(photoEntry.imageId)) {
                selectedPhotos.remove(photoEntry.imageId);
                add = false;
            } else {
                selectedPhotos.put(photoEntry.imageId, photoEntry);
            }
        } else {
            MediaController.SearchImage photoEntry;
            ArrayList<MediaController.SearchImage> array;
            if (searchResult.isEmpty() && lastSearchString == null) {
                array = recentImages;
            } else {
                array = searchResult;
            }
            if (index < 0 || index >= array.size()) {
                return;
            }
            photoEntry = array.get(index);
            if (selectedWebPhotos.containsKey(photoEntry.id)) {
                selectedWebPhotos.remove(photoEntry.id);
                add = false;
            } else {
                selectedWebPhotos.put(photoEntry.id, photoEntry);
            }
        }
        int count = listView.getChildCount();
        for (int a = 0; a < count; a++) {
            View view = listView.getChildAt(a);
            int num = (Integer) view.getTag();
            if (num == index) {
                ((PhotoPickerPhotoCell) view).setChecked(add, false);
                break;
            }
        }
        pickerBottomLayout.updateSelectedCount(selectedPhotos.size() + selectedWebPhotos.size(), true);
        delegate.selectedPhotosChanged();
    }

    @Override
    public boolean cancelButtonPressed() {
        delegate.actionButtonPressed(true);
        finishFragment();
        return true;
    }

    @Override
    public void sendButtonPressed(int index, VideoEditedInfo videoEditedInfo) {
        if (selectedAlbum != null) {
            if (selectedPhotos.isEmpty()) {
                if (index < 0 || index >= selectedAlbum.photos.size()) {
                    return;
                }
                MediaController.PhotoEntry photoEntry = selectedAlbum.photos.get(index);
                selectedPhotos.put(photoEntry.imageId, photoEntry);
            }
        } else if (selectedPhotos.isEmpty()) {
            ArrayList<MediaController.SearchImage> array;
            if (searchResult.isEmpty() && lastSearchString == null) {
                array = recentImages;
            } else {
                array = searchResult;
            }
            if (index < 0 || index >= array.size()) {
                return;
            }
            MediaController.SearchImage photoEntry = array.get(index);
            selectedWebPhotos.put(photoEntry.id, photoEntry);
        }
        sendSelectedPhotos();
    }

    @Override
    public int getSelectedCount() {
        return selectedPhotos.size() + selectedWebPhotos.size();
    }

    @Override
    public void onTransitionAnimationEnd(boolean isOpen, boolean backward) {
        if (isOpen && searchItem != null) {
            AndroidUtilities.showKeyboard(searchItem.getSearchField());
        }
    }

    private void updateSearchInterface() {
        if (listAdapter != null) {
            listAdapter.notifyDataSetChanged();
        }
        if (searching && searchResult.isEmpty() || loadingRecent && lastSearchString == null) {
            emptyView.showProgress();
        } else {
            emptyView.showTextView();
        }
    }

    public void setDelegate(PhotoPickerActivityDelegate delegate) {
        this.delegate = delegate;
    }

    private void sendSelectedPhotos() {
        if (selectedPhotos.isEmpty() && selectedWebPhotos.isEmpty() || delegate == null || sendPressed) {
            return;
        }
        sendPressed = true;
        delegate.actionButtonPressed(false);
        finishFragment();
    }

    private void fixLayout() {
        if (listView != null) {
            ViewTreeObserver obs = listView.getViewTreeObserver();
            obs.addOnPreDrawListener(new ViewTreeObserver.OnPreDrawListener() {
                @Override
                public boolean onPreDraw() {
                    fixLayoutInternal();
                    if (listView != null) {
                        listView.getViewTreeObserver().removeOnPreDrawListener(this);
                    }
                    return true;
                }
            });
        }
    }

    private void fixLayoutInternal() {
        if (getParentActivity() == null) {
            return;
        }
        int position = layoutManager.findFirstVisibleItemPosition();
        WindowManager manager = (WindowManager) ApplicationLoader.applicationContext.getSystemService(Activity.WINDOW_SERVICE);
        int rotation = manager.getDefaultDisplay().getRotation();

        int columnsCount;
        if (AndroidUtilities.isTablet()) {
            columnsCount = 3;
        } else {
            if (rotation == Surface.ROTATION_270 || rotation == Surface.ROTATION_90) {
                columnsCount = 5;
            } else {
                columnsCount = 3;
            }
        }
        layoutManager.setSpanCount(columnsCount);
        if (AndroidUtilities.isTablet()) {
            itemWidth = (AndroidUtilities.dp(490) - ((columnsCount + 1) * AndroidUtilities.dp(4))) / columnsCount;
        } else {
            itemWidth = (AndroidUtilities.displaySize.x - ((columnsCount + 1) * AndroidUtilities.dp(4))) / columnsCount;
        }

        listAdapter.notifyDataSetChanged();
        layoutManager.scrollToPosition(position);

        if (selectedAlbum == null) {
            emptyView.setPadding(0, 0, 0, (int) ((AndroidUtilities.displaySize.y - ActionBar.getCurrentActionBarHeight()) * 0.4f));
        }
    }

    private class ListAdapter extends RecyclerListView.SelectionAdapter {

        private Context mContext;

        public ListAdapter(Context context) {
            mContext = context;
        }

        @Override
        public boolean isEnabled(RecyclerView.ViewHolder holder) {
            if (selectedAlbum == null) {
                int position = holder.getAdapterPosition();
                if (searchResult.isEmpty() && lastSearchString == null) {
                    return position < recentImages.size();
                } else {
                    return position < searchResult.size();
                }
            }
            return true;
        }

        @Override
        public int getItemCount() {
            if (selectedAlbum == null) {
                if (searchResult.isEmpty() && lastSearchString == null) {
                    return recentImages.size();
                } else if (type == 0) {
                    return searchResult.size() + (bingSearchEndReached ? 0 : 1);
                } else if (type == 1) {
                    return searchResult.size() + (giphySearchEndReached ? 0 : 1);
                }
            }
            return selectedAlbum.photos.size();
        }

        @Override
        public long getItemId(int i) {
            return i;
        }

        @Override
        public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
            View view;
            switch (viewType) {
                case 0:
                    PhotoPickerPhotoCell cell = new PhotoPickerPhotoCell(mContext);
                    cell.checkFrame.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            int index = (Integer) ((View) v.getParent()).getTag();
                            if (selectedAlbum != null) {
                                MediaController.PhotoEntry photoEntry = selectedAlbum.photos.get(index);
                                if (selectedPhotos.containsKey(photoEntry.imageId)) {
                                    selectedPhotos.remove(photoEntry.imageId);
                                    photoEntry.imagePath = null;
                                    photoEntry.thumbPath = null;
                                    photoEntry.stickers.clear();
                                    updatePhotoAtIndex(index);
                                } else {
                                    selectedPhotos.put(photoEntry.imageId, photoEntry);
                                }
                                ((PhotoPickerPhotoCell) v.getParent()).setChecked(selectedPhotos.containsKey(photoEntry.imageId), true);
                            } else {
                                AndroidUtilities.hideKeyboard(getParentActivity().getCurrentFocus());
                                MediaController.SearchImage photoEntry;
                                if (searchResult.isEmpty() && lastSearchString == null) {
                                    photoEntry = recentImages.get((Integer) ((View) v.getParent()).getTag());
                                } else {
                                    photoEntry = searchResult.get((Integer) ((View) v.getParent()).getTag());
                                }
                                if (selectedWebPhotos.containsKey(photoEntry.id)) {
                                    selectedWebPhotos.remove(photoEntry.id);
                                    photoEntry.imagePath = null;
                                    photoEntry.thumbPath = null;
                                    updatePhotoAtIndex(index);
                                } else {
                                    selectedWebPhotos.put(photoEntry.id, photoEntry);
                                }
                                ((PhotoPickerPhotoCell) v.getParent()).setChecked(selectedWebPhotos.containsKey(photoEntry.id), true);
                            }
                            pickerBottomLayout.updateSelectedCount(selectedPhotos.size() + selectedWebPhotos.size(), true);
                            delegate.selectedPhotosChanged();
                        }
                    });
                    cell.checkFrame.setVisibility(singlePhoto ? View.GONE : View.VISIBLE);
                    view = cell;
                    break;
                case 1:
                default:
                    FrameLayout frameLayout = new FrameLayout(mContext);
                    view = frameLayout;
                    RadialProgressView progressBar = new RadialProgressView(mContext);
                    progressBar.setProgressColor(0xffffffff);
                    frameLayout.addView(progressBar, LayoutHelper.createFrame(LayoutHelper.MATCH_PARENT, LayoutHelper.MATCH_PARENT));
                    break;
            }
            return new RecyclerListView.Holder(view);
        }

        @Override
        public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
            switch (holder.getItemViewType()) {
                case 0:
                    PhotoPickerPhotoCell cell = (PhotoPickerPhotoCell) holder.itemView;
                    cell.itemWidth = itemWidth;
                    BackupImageView imageView = cell.photoImage;
                    imageView.setTag(position);
                    cell.setTag(position);
                    boolean showing;
                    imageView.setOrientation(0, true);

                    if (selectedAlbum != null) {
                        MediaController.PhotoEntry photoEntry = selectedAlbum.photos.get(position);
                        if (photoEntry.thumbPath != null) {
                            imageView.setImage(photoEntry.thumbPath, null, mContext.getResources().getDrawable(R.drawable.nophotos));
                        } else if (photoEntry.path != null) {
                            imageView.setOrientation(photoEntry.orientation, true);
                            if (photoEntry.isVideo) {
                                imageView.setImage("vthumb://" + photoEntry.imageId + ":" + photoEntry.path, null, mContext.getResources().getDrawable(R.drawable.nophotos));
                            } else {
                                imageView.setImage("thumb://" + photoEntry.imageId + ":" + photoEntry.path, null, mContext.getResources().getDrawable(R.drawable.nophotos));
                            }
                        } else {
                            imageView.setImageResource(R.drawable.nophotos);
                        }
                        cell.setChecked(selectedPhotos.containsKey(photoEntry.imageId), false);
                        showing = PhotoViewer.getInstance().isShowingImage(photoEntry.path);
                    } else {
                        MediaController.SearchImage photoEntry;
                        if (searchResult.isEmpty() && lastSearchString == null) {
                            photoEntry = recentImages.get(position);
                        } else {
                            photoEntry = searchResult.get(position);
                        }
                        if (photoEntry.thumbPath != null) {
                            imageView.setImage(photoEntry.thumbPath, null, mContext.getResources().getDrawable(R.drawable.nophotos));
                        } else if (photoEntry.thumbUrl != null && photoEntry.thumbUrl.length() > 0) {
                            imageView.setImage(photoEntry.thumbUrl, null, mContext.getResources().getDrawable(R.drawable.nophotos));
                        } else if (photoEntry.document != null && photoEntry.document.thumb != null) {
                            imageView.setImage(photoEntry.document.thumb.location, null, mContext.getResources().getDrawable(R.drawable.nophotos));
                        } else {
                            imageView.setImageResource(R.drawable.nophotos);
                        }
                        cell.setChecked(selectedWebPhotos.containsKey(photoEntry.id), false);
                        if (photoEntry.document != null) {
                            showing = PhotoViewer.getInstance().isShowingImage(FileLoader.getPathToAttach(photoEntry.document, true).getAbsolutePath());
                        } else {
                            showing = PhotoViewer.getInstance().isShowingImage(photoEntry.imageUrl);
                        }
                    }
                    imageView.getImageReceiver().setVisible(!showing, true);
                    cell.checkBox.setVisibility(singlePhoto || showing ? View.GONE : View.VISIBLE);
                    break;
                case 1:
                    ViewGroup.LayoutParams params = holder.itemView.getLayoutParams();
                    if (params != null) {
                        params.width = itemWidth;
                        params.height = itemWidth;
                        holder.itemView.setLayoutParams(params);
                    }
                    break;
            }
        }

        @Override
        public int getItemViewType(int i) {
            if (selectedAlbum != null || searchResult.isEmpty() && lastSearchString == null && i < recentImages.size() || i < searchResult.size()) {
                return 0;
            }
            return 1;
        }
    }
}

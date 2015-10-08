/*
 * This is the source code of Telegram for Android v. 1.3.2.
 * It is licensed under GNU GPL v. 2 or later.
 * You should have received a copy of the license in this archive (see LICENSE).
 *
 * Copyright Nikolai Kudashov, 2013.
 */

package org.telegram.messenger;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.text.Spannable;
import android.text.Spanned;
import android.text.style.DynamicDrawableSpan;
import android.text.style.ImageSpan;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.io.File;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Locale;

public class Emoji {
    private static HashMap<Long, DrawableInfo> rects = new HashMap<>();
    private static int drawImgSize;
    private static int bigImgSize;
    private static boolean inited = false;
    private static Paint placeholderPaint;
    private static Bitmap emojiBmp;
    private static boolean loadingEmoji[] = new boolean[5];

    private static final char[] emojiChars = {
            0x00A9, 0x00AE, 0x203C, 0x2049, 0x2122, 0x2139, 0x2194, 0x2195, 0x2196, 0x2197,
            0x2198, 0x2199, 0x21A9, 0x21AA, 0x231A, 0x231B, 0x23E9, 0x23EA, 0x23EB, 0x23EC,
            0x23F0, 0x23F3, 0x24C2, 0x25AA, 0x25AB, 0x25B6, 0x25C0, 0x25FB, 0x25FC, 0x25FD,
            0x25FE, 0x2600, 0x2601, 0x260E, 0x2611, 0x2614, 0x2615, 0x261D, 0x263A, 0x2648,
            0x2649, 0x264A, 0x264B, 0x264C, 0x264D, 0x264E, 0x264F, 0x2650, 0x2651, 0x2652,
            0x2653, 0x2660, 0x2663, 0x2665, 0x2666, 0x2668, 0x267B, 0x267F, 0x2693, 0x26A0,
            0x26A1, 0x26AA, 0x26AB, 0x26BD, 0x26BE, 0x26C4, 0x26C5, 0x26CE, 0x26D4, 0x26EA,
            0x26F2, 0x26F3, 0x26F5, 0x26FA, 0x26FD, 0x2702, 0x2705, 0x2708, 0x2709, 0x270A,
            0x270B, 0x270C, 0x270F, 0x2712, 0x2714, 0x2716, 0x2728, 0x2733, 0x2734, 0x2744,
            0x2747, 0x274C, 0x274E, 0x2753, 0x2754, 0x2755, 0x2757, 0x2764, 0x2795, 0x2796,
            0x2797, 0x27A1, 0x27B0, 0x27BF, 0x2934, 0x2935, 0x2B05, 0x2B06, 0x2B07, 0x2B1B,
            0x2B1C, 0x2B50, 0x2B55, 0x3030, 0x303D, 0x3297, 0x3299
    };

    static {
        int emojiFullSize;
        if (AndroidUtilities.density <= 1.0f) {
            emojiFullSize = 32;
        } else if (AndroidUtilities.density <= 1.5f) {
            emojiFullSize = 48;
        } else if (AndroidUtilities.density <= 2.0f) {
            emojiFullSize = 64;
        } else {
            emojiFullSize = 64; // Maximum size is 64x64 or now.
        }
        drawImgSize = AndroidUtilities.dp(20);
        if (AndroidUtilities.isTablet()) {
            bigImgSize = AndroidUtilities.dp(40);
        } else {
            bigImgSize = AndroidUtilities.dp(32);
        }

        for (int j = 0; j < EmojiData.data.length; j++) {
            for (int i = 0; i < EmojiData.data[j].length; i++) {
                int left = EmojiData.offsets.get(EmojiData.data[j][i])[0];
                int top = EmojiData.offsets.get(EmojiData.data[j][i])[1];
                Rect rect = new Rect(left, top, left + 64, top + 64);
                rects.put(EmojiData.data[j][i], new DrawableInfo(rect, (byte) j));
            }
        }
        placeholderPaint = new Paint();
        placeholderPaint.setColor(0x00000000);
    }

    private static void loadEmoji() {
        try {
            String imageName;
            File imageFile;

            imageName = "emojione.sprites.png";
            imageFile = ApplicationLoader.applicationContext.getFileStreamPath(imageName);
            if (!imageFile.exists()) {
                InputStream is = ApplicationLoader.applicationContext.getAssets().open(imageName);
                AndroidUtilities.copyFile(is, imageFile);
                is.close();
            }

            final Bitmap bitmap = BitmapFactory.decodeFile(imageFile.getAbsolutePath());
            //final Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
            //Utilities.loadBitmap(imageFile.getAbsolutePath(), bitmap, imageResize, width, height, stride);

            AndroidUtilities.runOnUIThread(new Runnable() {
                @Override
                public void run() {
                    emojiBmp = bitmap;
                    NotificationCenter.getInstance().postNotificationName(NotificationCenter.emojiDidLoaded);
                }
            });
        } catch (Throwable x) {
            FileLog.e("tmessages", "Error loading emoji", x);
        }
    }

    private static void loadEmojiAsync(final int page) {
        if (loadingEmoji[page]) {
            return;
        }
        loadingEmoji[page] = true;
        new Thread(new Runnable() {
            public void run() {
                loadEmoji();
                loadingEmoji[page] = false;
            }
        }).start();
    }

    public static void invalidateAll(View view) {
        if (view instanceof ViewGroup) {
            ViewGroup g = (ViewGroup) view;
            for (int i = 0; i < g.getChildCount(); i++) {
                invalidateAll(g.getChildAt(i));
            }
        } else if (view instanceof TextView) {
            view.invalidate();
        }
    }

    public static EmojiDrawable getEmojiDrawable(long code) {
        DrawableInfo info = rects.get(code);
        if (info == null) {
            FileLog.e("tmessages", "No emoji drawable for code " + String.format("%016X", code));
            return null;
        }
        EmojiDrawable ed = new EmojiDrawable(info);
        ed.setBounds(0, 0, drawImgSize, drawImgSize);
        return ed;
    }

    public static Drawable getEmojiBigDrawable(long code) {
        EmojiDrawable ed = getEmojiDrawable(code);
        if (ed == null) {
            return null;
        }
        ed.setBounds(0, 0, bigImgSize, bigImgSize);
        ed.fullSize = true;
        return ed;
    }

    public static class EmojiDrawable extends Drawable {
        private DrawableInfo info;
        private boolean fullSize = false;
        private static Paint paint = new Paint(Paint.FILTER_BITMAP_FLAG | Paint.ANTI_ALIAS_FLAG);

        public EmojiDrawable(DrawableInfo i) {
            info = i;
        }

        public DrawableInfo getDrawableInfo() {
            return info;
        }

        public Rect getDrawRect() {
            Rect b = copyBounds();
            int cX = b.centerX(), cY = b.centerY();
            b.left = cX - (fullSize ? bigImgSize : drawImgSize) / 2;
            b.right = cX + (fullSize ? bigImgSize : drawImgSize) / 2;
            b.top = cY - (fullSize ? bigImgSize : drawImgSize) / 2;
            b.bottom = cY + (fullSize ? bigImgSize : drawImgSize) / 2;
            return b;
        }

        @Override
        public void draw(Canvas canvas) {
            if (emojiBmp == null) {
                loadEmojiAsync(info.page);
                canvas.drawRect(getBounds(), placeholderPaint);
                return;
            }
            Rect b;
            if (fullSize) {
                b = getDrawRect();
            } else {
                b = getBounds();
            }

            if (!canvas.quickReject(b.left, b.top, b.right, b.bottom, Canvas.EdgeType.AA)) {
                canvas.drawBitmap(emojiBmp, info.rect, b, paint);
            }
        }

        @Override
        public int getOpacity() {
            return 0;
        }

        @Override
        public void setAlpha(int alpha) {

        }

        @Override
        public void setColorFilter(ColorFilter cf) {

        }
    }

    private static class DrawableInfo {
        public Rect rect;
        public byte page;

        public DrawableInfo(Rect r, byte p) {
            rect = r;
            page = p;
        }
    }

    private static boolean inArray(char c, char[] a) {
        for (char cc : a) {
            if (cc == c) {
                return true;
            }
        }
        return false;
    }

    private static boolean isNextCharIsColor(CharSequence cs, int i) {
        if (i + 2 >= cs.length()) {
            return false;
        }
        int value = cs.charAt(i + 1) << 16 | cs.charAt(i + 2);
        return value == 0xd83cdffb || value == 0xd83cdffc || value == 0xd83cdffd || value == 0xd83cdffe || value == 0xd83cdfff;
    }

    public static CharSequence replaceEmoji(CharSequence cs, Paint.FontMetricsInt fontMetrics, int size, boolean createNew) {
        if (cs == null || cs.length() == 0) {
            return cs;
        }
        //SpannableStringLight.isFieldsAvailable();
        //SpannableStringLight s = new SpannableStringLight(cs.toString());
        Spannable s;
        if (!createNew && cs instanceof Spannable) {
            s = (Spannable) cs;
        } else {
            s = Spannable.Factory.getInstance().newSpannable(cs.toString());
        }
        long buf = 0;
        int emojiCount = 0;
        //s.setSpansCount(emojiCount);

        try {
            for (int i = 0; i < cs.length(); i++) {
                char c = cs.charAt(i);
                if (c == 0xD83C || c == 0xD83D || (buf != 0 && (buf & 0xFFFFFFFF00000000L) == 0 && (c >= 0xDDE6 && c <= 0xDDFA))) {
                    buf <<= 16;
                    buf |= c;
                } else if (buf > 0 && (c & 0xF000) == 0xD000) {
                    buf <<= 16;
                    buf |= c;
                    EmojiDrawable d = Emoji.getEmojiDrawable(buf);
                    if (d != null) {
                        boolean nextIsSkinTone = isNextCharIsColor(cs, i);
                        EmojiSpan span = new EmojiSpan(d, DynamicDrawableSpan.ALIGN_BOTTOM, size, fontMetrics);
                        if (c >= 0xDDE6 && c <= 0xDDFA) {
                            s.setSpan(span, i - 3, i + (nextIsSkinTone ? 3 : 1), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
                        } else {
                            s.setSpan(span, i - 1, i + (nextIsSkinTone ? 3 : 1), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
                        }
                        emojiCount++;
                        if (nextIsSkinTone) {
                            i += 2;
                        }
                    }
                    buf = 0;
                } else if (c == 0x20E3) {
                    if (i > 0) {
                        char c2 = cs.charAt(i - 1);
                        if ((c2 >= '0' && c2 <= '9') || c2 == '#') {
                            buf = c2;
                            buf <<= 16;
                            buf |= c;
                            EmojiDrawable d = Emoji.getEmojiDrawable(buf);
                            if (d != null) {
                                boolean nextIsSkinTone = isNextCharIsColor(cs, i);
                                EmojiSpan span = new EmojiSpan(d, DynamicDrawableSpan.ALIGN_BOTTOM, size, fontMetrics);
                                s.setSpan(span, i - 1, i + (nextIsSkinTone ? 3 : 1), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
                                emojiCount++;
                                if (nextIsSkinTone) {
                                    i += 2;
                                }
                            }
                            buf = 0;
                        }
                    }
                } else if (inArray(c, emojiChars)) {
                    EmojiDrawable d = Emoji.getEmojiDrawable(c);
                    if (d != null) {
                        boolean nextIsSkinTone = isNextCharIsColor(cs, i);
                        EmojiSpan span = new EmojiSpan(d, DynamicDrawableSpan.ALIGN_BOTTOM, size, fontMetrics);
                        s.setSpan(span, i, i + (nextIsSkinTone ? 3 : 1), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
                        emojiCount++;
                        if (nextIsSkinTone) {
                            i += 2;
                        }
                    }
                }
                if (emojiCount >= 50) {
                    break;
                }
            }
        } catch (Exception e) {
            FileLog.e("tmessages", e);
            return cs;
        }
        return s;
    }

    public static class EmojiSpan extends ImageSpan {
        private Paint.FontMetricsInt fontMetrics = null;
        private int size = AndroidUtilities.dp(20);

        public EmojiSpan(EmojiDrawable d, int verticalAlignment, int s, Paint.FontMetricsInt original) {
            super(d, verticalAlignment);
            fontMetrics = original;
            if (original != null) {
                size = Math.abs(fontMetrics.descent) + Math.abs(fontMetrics.ascent);
                if (size == 0) {
                    size = AndroidUtilities.dp(20);
                }
            }
        }

        @Override
        public int getSize(Paint paint, CharSequence text, int start, int end, Paint.FontMetricsInt fm) {
            if (fm == null) {
                fm = new Paint.FontMetricsInt();
            }

            if (fontMetrics == null) {
                int sz = super.getSize(paint, text, start, end, fm);

                int offset = AndroidUtilities.dp(8);
                int w = AndroidUtilities.dp(10);
                fm.top = -w - offset;
                fm.bottom = w - offset;
                fm.ascent = -w - offset;
                fm.leading = 0;
                fm.descent = w - offset;

                return sz;
            } else {
                if (fm != null) {
                    fm.ascent = fontMetrics.ascent;
                    fm.descent = fontMetrics.descent;

                    fm.top = fontMetrics.top;
                    fm.bottom = fontMetrics.bottom;
                }
                if (getDrawable() != null) {
                    getDrawable().setBounds(0, 0, size, size);
                }
                return size;
            }
        }
    }
}

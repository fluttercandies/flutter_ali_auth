package com.fluttercandies.flutter_ali_auth.config;

import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.PixelFormat;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.drawable.Drawable;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public class DialogBackgroundDrawable extends Drawable {
    /**
     * 背景
     */
    private Paint mPaint;
    /**
     * 边框
     */
    private Paint mStrokePaint;
    private Path mPath;
    private RectF mRectF;
    private float mCornerRadius;
    private Float mBorderWidth;

    public DialogBackgroundDrawable(float cornerRadius, int color, Float borderWidth, Integer borderColor) {
        mCornerRadius = cornerRadius;
        mBorderWidth = borderWidth;
        mPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        mPaint.setColor(color);
        mPath = new Path();
        mRectF = new RectF();
        mStrokePaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        mStrokePaint.setStyle(Paint.Style.STROKE);
        mStrokePaint.setStrokeWidth(borderWidth);
        if (borderColor != null){
            mStrokePaint.setColor(borderColor);
        }
    }


    @Override
    public void draw(@NonNull Canvas canvas) {
        mPath.reset();
        mRectF.set(getBounds());
        if (mBorderWidth != null) {
            mRectF.inset(mBorderWidth / 2, mBorderWidth / 2);
        }
        mPath.addRoundRect(mRectF, mCornerRadius, mCornerRadius, Path.Direction.CW);
        canvas.drawPath(mPath, mPaint);
        canvas.drawPath(mPath, mStrokePaint);
    }

    @Override
    public void setAlpha(int alpha) {
        mPaint.setAlpha(alpha);
    }

    @Override
    public void setColorFilter(@Nullable ColorFilter colorFilter) {
        mPaint.setColorFilter(colorFilter);
    }

    @Override
    public int getOpacity() {
        return PixelFormat.TRANSLUCENT;
    }

    @Override
    protected void onBoundsChange(Rect bounds) {
        super.onBoundsChange(bounds);
        mRectF.set(bounds);
    }


}

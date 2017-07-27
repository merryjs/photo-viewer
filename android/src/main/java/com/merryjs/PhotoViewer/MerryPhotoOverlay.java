package com.merryjs.PhotoViewer;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.util.AttributeSet;
import android.view.View;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.merryjs.R;

/**
 * Created by bang on 26/07/2017.
 */

public class MerryPhotoOverlay extends RelativeLayout {
    private TextView tvTitle;
    private TextView tvTitlePager;

    private TextView tvDescription;
    private TextView tvShare;
    private String sharingText;

    public MerryPhotoOverlay(Context context) {
        super(context);
        init();
    }

    public MerryPhotoOverlay(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public MerryPhotoOverlay(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }

    public void setPagerText(String text) {
        tvTitlePager.setText(text);
    }

    public void setPagerTextColor(String color) {
        tvTitlePager.setTextColor(Color.parseColor(color));
    }

    public void setDescription(String description) {
        tvDescription.setText(description);
    }

    public void setDescriptionTextColor(String color) {
        tvDescription.setTextColor(Color.parseColor(color));
    }

    public void setShareText(String text) {
        tvShare.setText(text);
    }

    public void setShareContext(String text) {
        this.sharingText = text;
    }

    public void setShareTextColor(String color) {
        tvShare.setTextColor(Color.parseColor(color));
    }

    public void setTitleTextColor(String color) {
        tvTitle.setTextColor(Color.parseColor(color));
    }

    public void setTitleText(String text) {
        tvTitle.setText(text);
    }

    private void sendShareIntent() {
        Intent sendIntent = new Intent();
        sendIntent.setAction(Intent.ACTION_SEND);
        sendIntent.putExtra(Intent.EXTRA_TEXT, sharingText);
        sendIntent.setType("text/plain");
        getContext().startActivity(sendIntent);
    }

    private void init() {
        View view = inflate(getContext(), R.layout.photo_viewer_overlay, this);

        tvTitlePager = (TextView) view.findViewById(R.id.tvTitlePager);
        tvTitle = (TextView) view.findViewById(R.id.tvTitle);
        tvDescription = (TextView) view.findViewById(R.id.tvDescription);

        tvShare = (TextView) view.findViewById(R.id.btnShare);
        tvShare.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                sendShareIntent();
            }
        });
    }
}

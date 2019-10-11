
package com.merryjs.PhotoViewer;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.util.AttributeSet;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.core.content.ContextCompat;

import com.stfalcon.frescoimageviewer.ImageViewer;

import java.util.ArrayList;
import java.util.List;


/**
 * Created by bang on 26/07/2017.
 */

public class MerryPhotoOverlay extends RelativeLayout {
    private TextView tvTitle;
    private TextView tvTitlePager;
    private TextView tvDescription;
    private ImageView tvShare;
    private ImageView tvClose;
    private ImageView ivCollect;
    private ImageView ivSimilar;
    private ImageViewer imageViewer;
    private String sharingText;
    private List<MerryPhotoOverlayListener> merryPhotoOverlayListeners = new ArrayList<>();
    private boolean isEnabledCollect;
    private boolean isDismissOnCollect;
    private boolean isEnableSimilarImages;
    private boolean isShowProjectDetailButton;
    private boolean isCollect;

    public void setImageViewer(ImageViewer imageViewer) {
        this.imageViewer = imageViewer;
    }

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

    public void registerMerryPhotoOverlayListener(MerryPhotoOverlayListener merryPhotoOverlayListener) {
        this.merryPhotoOverlayListeners.add(merryPhotoOverlayListener);
    }

    public void setHideShareButton(Boolean hideShareButton) {
        tvShare.setVisibility(hideShareButton ? View.GONE : View.VISIBLE);
    }

    public void setHideCloseButton(Boolean hideCloseButton) {
        tvClose.setVisibility(hideCloseButton ? View.GONE : View.VISIBLE);
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

    public void setDescriptionTextColor(int color) {
        tvDescription.setTextColor(color);
    }

    public void setShareContext(String text) {
        this.sharingText = text;
    }

    public void setTitleTextColor(int color) {
        tvTitle.setTextColor(color);
    }

    public void setEnableCollect(Boolean isEnabledCollect) {
        if (isEnabledCollect) {
            ivCollect.setVisibility(View.VISIBLE);
        } else {
            ivCollect.setVisibility(View.GONE);
        }
        this.isEnabledCollect = isEnabledCollect;
    }

    public void setDismissOnCollect(Boolean isDismissOnCollect) {
        this.isDismissOnCollect = isDismissOnCollect;
    }

    public void setEnableSimilarImages(Boolean isEnableSimilarImages) {
        this.isEnableSimilarImages = isEnableSimilarImages;
        if (isEnableSimilarImages) {
            ivSimilar.setVisibility(View.VISIBLE);
        } else {
            ivSimilar.setVisibility(View.GONE);
        }
    }

    public void setIsCollect(boolean isCollect) {
        this.isCollect = isCollect;
        if (isCollect) {
            ivCollect.setImageDrawable(ContextCompat.getDrawable(getContext(), R.drawable.ic_heart));
        } else {
            ivCollect.setImageDrawable(ContextCompat.getDrawable(getContext(), R.drawable.ic_heart_outline));
        }
    }

    public void setTitleText(String text) {
        text = text.replaceAll("\\n\\n", "\n");
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

        isCollect = false;

        tvTitlePager = (TextView) view.findViewById(R.id.tvTitlePager);
        tvTitle = (TextView) view.findViewById(R.id.tvTitle);
        tvDescription = (TextView) view.findViewById(R.id.tvDescription);

        tvShare = (ImageView) view.findViewById(R.id.btnShare);
        tvShare.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                notifyOnShareClicked();
                sendShareIntent();
            }
        });
        tvClose = (ImageView) view.findViewById(R.id.btnClose);
        tvClose.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                imageViewer.onDismiss();
            }
        });

        ivCollect = (ImageView) view.findViewById(R.id.ivCollect);
        ivCollect.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                setIsCollect(!isCollect);
                if (isDismissOnCollect) {
                    imageViewer.onDismiss();
                }
                if (isCollect) {
                    notifyOnCollectClicked();
                } else {
                    notifyOnUnCollectClicked();
                }
            }
        });

        ivSimilar = (ImageView) view.findViewById(R.id.ivSimilar);
        ivSimilar.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                imageViewer.onDismiss();
                notifyOnSimilarClicked();
            }
        });

    }

    private void notifyOnShareClicked() {
        for (MerryPhotoOverlayListener merryPhotoOverlayListener :
                merryPhotoOverlayListeners) {
            merryPhotoOverlayListener.onShareClicked();
        }
    }

    private void notifyOnCollectClicked() {
        for (MerryPhotoOverlayListener merryPhotoOverlayListener :
                merryPhotoOverlayListeners) {
            merryPhotoOverlayListener.onCollectClicked();
        }
    }

    private void notifyOnUnCollectClicked() {
        for (MerryPhotoOverlayListener merryPhotoOverlayListener :
                merryPhotoOverlayListeners) {
            merryPhotoOverlayListener.onUnCollectClicked();
        }
    }

    private void notifyOnSimilarClicked() {
        for (MerryPhotoOverlayListener merryPhotoOverlayListener :
                merryPhotoOverlayListeners) {
            merryPhotoOverlayListener.onSimilarClicked();
        }
    }


    interface MerryPhotoOverlayListener {

        void onShareClicked();

        void onCollectClicked();

        void onUnCollectClicked();

        void onSimilarClicked();

    }
}

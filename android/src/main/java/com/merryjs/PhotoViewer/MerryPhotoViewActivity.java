package com.merryjs.PhotoViewer;

import android.app.Activity;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.view.Menu;
import android.view.MenuItem;

import com.facebook.drawee.generic.GenericDraweeHierarchyBuilder;
import com.facebook.drawee.generic.RoundingParams;
import com.google.gson.Gson;
import com.merryexamples.R;
import com.stfalcon.frescoimageviewer.ImageViewer;

import java.util.Random;

/**
 * Created by bang on 26/07/2017.
 */

public class MerryPhotoViewActivity extends AppCompatActivity {
    private MerryPhotoOverlay overlayView;
    private MerryPhotoViewOptions options;
    private Activity mActivity;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mActivity = this;
        setContentView(R.layout.merry_photo_activity);

        String o = getIntent().getStringExtra("options");
        options = new Gson().fromJson(o, MerryPhotoViewOptions.class);

        if (options != null) {
            //The key argument here must match that used in the other activity
            showPicker(options);
        }
    }

    protected void showPicker(MerryPhotoViewOptions merryPhotoViewOptions) {
        // catch exceptions
        int startPosition = merryPhotoViewOptions.initial;

        int total = merryPhotoViewOptions.data.length;

        if (startPosition < 0) {
            startPosition = 0;
        }

        if (startPosition >= total) {
            startPosition = total;
        }

        ImageViewer.Builder builder = new ImageViewer.Builder(this, merryPhotoViewOptions.data)
                .setStartPosition(startPosition)
                .setFormatter(new ImageViewer.Formatter<MerryPhotoData>() {
                    @Override
                    public String format(MerryPhotoData o) {
                        return o.url;
                    }
                })
                .hideStatusBar(merryPhotoViewOptions.hideStatusBar)
                .setOnDismissListener(getDismissListener());
//
//
//        if (options.get(MerryPhotoViewOptions.Property.IMAGE_MARGIN)) {
//            builder.setImageMargin(this, R.dimen.image_margin);
//        }
//
//        if (options.get(MerryPhotoViewOptions.Property.CONTAINER_PADDING)) {
//            builder.setContainerPadding(this, R.dimen.image_margin);
//        }
//
//        if (options.get(MerryPhotoViewOptions.Property.IMAGES_ROUNDING)) {
//            builder.setCustomDraweeHierarchyBuilder(getRoundedHierarchyBuilder());
//        }
//
        builder.allowSwipeToDismiss(merryPhotoViewOptions.swipeToDismiss);
//
        builder.allowZooming(merryPhotoViewOptions.zooming);
//
        overlayView = new MerryPhotoOverlay(this);
        builder.setOverlayView(overlayView);
        builder.setImageChangeListener(getImageChangeListener());
//
        if (options.backgroundColor != null) {
            builder.setBackgroundColor(Color.parseColor(options.backgroundColor));
        }
//
//        if (options.get(MerryPhotoViewOptions.Property.POST_PROCESSING)) {
//            builder.setCustomImageRequestBuilder(
//                    ImageViewer.createImageRequestBuilder()
//                            .setPostprocessor(new GrayscalePostprocessor()));
//        }

        builder.show();
    }


    private ImageViewer.OnImageChangeListener getImageChangeListener() {
        return new ImageViewer.OnImageChangeListener() {
            @Override
            public void onImageChange(int position) {

                MerryPhotoData merryPhotoData = options.data[position];
                String url = merryPhotoData.url;
//                default use url
                overlayView.setShareContext(url);

                overlayView.setDescription(merryPhotoData.summary);
                overlayView.setTitleText(merryPhotoData.title);

                String summaryColor = "#ffffff";
                String titleColor = "#ffffff";
                if (options.shareText != null) {
                    overlayView.setShareText(options.shareText);
                }
                if (options.titlePagerColor != null) {
                    overlayView.setPagerTextColor(options.titlePagerColor);
                }

                overlayView.setPagerText((position + 1) + " / " + options.data.length);

                if (merryPhotoData.titleColor != null) {
                    titleColor = merryPhotoData.titleColor;
                }
                overlayView.setTitleTextColor(titleColor);
                if (merryPhotoData.summaryColor != null) {
                    summaryColor = merryPhotoData.summaryColor;
                }
                overlayView.setDescriptionTextColor(summaryColor);

                if (options.shareTextColor != null) {
                    overlayView.setShareTextColor(options.shareTextColor);
                }
            }
        };
    }

    //
    private ImageViewer.OnDismissListener getDismissListener() {
        return new ImageViewer.OnDismissListener() {
            @Override
            public void onDismiss() {
                mActivity.finish();

            }
        };
    }
//
//    private GenericDraweeHierarchyBuilder getRoundedHierarchyBuilder() {
//        RoundingParams roundingParams = new RoundingParams();
//        roundingParams.setRoundAsCircle(true);
//
//        return GenericDraweeHierarchyBuilder.newInstance(getResources())
//                .setRoundingParams(roundingParams);
//    }
//
//    private int getRandomColor() {
//        Random random = new Random();
//        return Color.argb(255, random.nextInt(156), random.nextInt(156), random.nextInt(156));
//    }
}

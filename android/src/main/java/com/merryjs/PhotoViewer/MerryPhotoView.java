
package com.merryjs.PhotoViewer;

import android.content.Context;
import android.graphics.Color;
import android.view.View;

import com.facebook.drawee.generic.GenericDraweeHierarchyBuilder;
import com.facebook.imagepipeline.request.ImageRequestBuilder;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.stfalcon.frescoimageviewer.ImageViewer;
import com.facebook.react.views.imagehelper.ImageSource;

/**
 * Created by bang on 07/08/2017.
 */

public class MerryPhotoView extends View {

    private MerryPhotoOverlay overlayView;
    protected ImageViewer.Builder builder;

    public MerryPhotoData[] getData() {
        return data;
    }

    public MerryPhotoView setData(MerryPhotoData[] data) {
        this.data = data;
        return this;
    }

    protected MerryPhotoData[] data;

    public String getShareText() {
        return shareText;
    }

    public MerryPhotoView setShareText(String shareText) {
        this.shareText = shareText;
        return this;
    }

    protected String shareText;


    protected int initial;

    public int getInitial() {
        return initial;
    }

    public MerryPhotoView setInitial(int initial) {
        this.initial = initial;
        return this;
    }

    public boolean isHideStatusBar() {
        return hideStatusBar;
    }

    public MerryPhotoView setHideStatusBar(boolean hideStatusBar) {
        this.hideStatusBar = hideStatusBar;
        return this;
    }

    protected boolean hideStatusBar;


    public boolean isHideShareButton() {
        return hideShareButton;
    }

    public MerryPhotoView setHideShareButton(boolean hideShareButton) {
        this.hideShareButton = hideShareButton;
        return this;
    }

    protected boolean hideShareButton;

    protected boolean hideTitle;

    public boolean isHideTitle() {
        return hideTitle;
    }

    public MerryPhotoView setHideTitle(boolean hideTitle) {
        this.hideTitle = hideTitle;
        return this;
    }

    protected boolean hideCloseButton;

    public boolean isHideCloseButton() {
        return hideCloseButton;
    }

    public MerryPhotoView setHideCloseButton(boolean hideCloseButton) {
        this.hideCloseButton = hideCloseButton;
        return this;
    }


    public MerryPhotoView(Context context) {
        super(context);
    }


    protected void init() {
        if(builder != null){
            return;
        }
        final Context context = getContext();
        builder = new ImageViewer.Builder(context, getData())
                .setFormatter(new ImageViewer.Formatter<MerryPhotoData>() {
                    @Override
                    public String format(MerryPhotoData o) {
                        return o.source.getString("uri");
                    }
                })
                .setOnDismissListener(getDismissListener());


        builder.setImageChangeListener(getImageChangeListener());
        builder.setStartPosition(getInitial());
        builder.hideStatusBar(isHideStatusBar());
        // builder.setCustomImageRequestBuilder(getLocalImage());
        builder.setCustomDraweeHierarchyBuilder(progressBarDrawableBuilder());
        overlayView = new MerryPhotoOverlay(context);
        builder.setOverlayView(overlayView);

        ImageViewer imageViewer = builder.build();
        overlayView.setImageViewer(imageViewer);
        imageViewer.show();
    }

    private ImageRequestBuilder getLocalImage() {
        final Context context = getContext();

        ImageSource imageSource = new ImageSource(context, "cat-2575694_1920");

        ImageRequestBuilder imageRequestBuilder = ImageRequestBuilder.newBuilderWithSource(imageSource.getUri());
        return imageRequestBuilder;
    }

    private ImageViewer.OnImageChangeListener getImageChangeListener() {
        return new ImageViewer.OnImageChangeListener() {
            @Override
            public void onImageChange(int position) {

                final MerryPhotoData merryPhotoData = getData()[position];
                String url = merryPhotoData.source.getString("uri");
//                default use url
                overlayView.setShareContext(url);

                overlayView.setDescription(merryPhotoData.summary);
                overlayView.setTitleText(merryPhotoData.title);

                int summaryColor = Color.WHITE;
                int titleColor = Color.WHITE;
                if (getShareText() != null) {
                    overlayView.setShareText(getShareText());
                }

                // is hide sharebutton
                overlayView.setHideShareButton(isHideShareButton());
                overlayView.setHideCloseButton(isHideCloseButton());
                overlayView.setHideTitle(isHideTitle());

//                if (options.titlePagerColor != null) {
//                    overlayView.setPagerTextColor(options.titlePagerColor);
//                }
//
                overlayView.setPagerText((position + 1) + " / " + getData().length);
                if (merryPhotoData.titleColor != 0) {

                    titleColor = merryPhotoData.titleColor;
                }
                overlayView.setTitleTextColor(titleColor);
                if (merryPhotoData.summaryColor != 0) {
                    summaryColor = merryPhotoData.summaryColor;
                }
                overlayView.setDescriptionTextColor(summaryColor);

                WritableMap writableMap = Arguments.createMap();
                writableMap.putString("title", merryPhotoData.title);
                writableMap.putString("summary", merryPhotoData.summary);
                writableMap.putInt("summaryColor", merryPhotoData.summaryColor);
                writableMap.putInt("titleColor", merryPhotoData.titleColor);
                writableMap.putMap("source", Utils.toWritableMap(merryPhotoData.source));

                // onChange event from js side
                WritableMap map = Arguments.createMap();
                map.putMap("photo", writableMap);
                map.putInt("index", position);

                onNavigateToPhoto(map);

            }
        };
    }

    /**
     * on dismiss
     */
    protected void onDialogDismiss() {
        final Context context = getContext();
        builder = null;
        overlayView = null;
        if (context instanceof ReactContext) {
            ((ReactContext) context).getJSModule(RCTEventEmitter.class).receiveEvent(getId(), "onDismiss", null);
        }
    }

    /**
     * on photo change
     */
    protected void onNavigateToPhoto(WritableMap map) {
        final Context context = getContext();
        if (context instanceof ReactContext) {
            ((ReactContext) context).getJSModule(RCTEventEmitter.class).receiveEvent(getId(), "onChange", map);
        }
    }

    //
    private ImageViewer.OnDismissListener getDismissListener() {
        return new ImageViewer.OnDismissListener() {
            @Override
            public void onDismiss() {
                onDialogDismiss();
            }
        };
    }

    private GenericDraweeHierarchyBuilder progressBarDrawableBuilder() {
        return GenericDraweeHierarchyBuilder.newInstance(getResources())
                .setProgressBarImage(
                        new CircleProgressBarDrawable()
                );
    }
}

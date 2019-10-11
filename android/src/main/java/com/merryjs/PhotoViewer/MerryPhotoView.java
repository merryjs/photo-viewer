
package com.merryjs.PhotoViewer;

import android.content.Context;
import android.graphics.Color;
import android.view.View;

import com.facebook.drawee.generic.GenericDraweeHierarchyBuilder;
import com.facebook.imagepipeline.request.ImageRequestBuilder;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.facebook.react.views.imagehelper.ImageSource;
import com.stfalcon.frescoimageviewer.ImageViewer;

/**
 * Created by bang on 07/08/2017.
 */

public class MerryPhotoView extends View implements ImageViewer.OnImageChangeListener, MerryPhotoOverlay.MerryPhotoOverlayListener {

    protected ImageViewer.Builder builder;
    protected String shareText;
    protected int initial;
    private MerryPhotoOverlay overlayView;
    protected MerryPhotoData[] data;
    protected boolean hideStatusBar;
    protected boolean hideShareButton;
    protected boolean hideCloseButton;
    protected boolean isEnabledCollect;
    protected boolean isDismissOnCollect;
    protected boolean isEnableSimilarImages;
    protected boolean isShowProjectDetailButton;
    private MerryPhotoData merryPhotoData;
    private int position;

    public MerryPhotoData[] getData() {
        return data;
    }

    public MerryPhotoView setData(MerryPhotoData[] data) {
        this.data = data;
        return this;
    }

    public String getShareText() {
        return shareText;
    }

    public MerryPhotoView setShareText(String shareText) {
        this.shareText = shareText;
        return this;
    }

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

    public boolean isHideShareButton() {
        return hideShareButton;
    }

    public MerryPhotoView setHideShareButton(boolean hideShareButton) {
        this.hideShareButton = hideShareButton;
        return this;
    }

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
        if (builder != null) {
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


        builder.setImageChangeListener(this);
        builder.setStartPosition(getInitial());
        builder.hideStatusBar(isHideStatusBar());
        // builder.setCustomImageRequestBuilder(getLocalImage());
        builder.setCustomDraweeHierarchyBuilder(progressBarDrawableBuilder());
        overlayView = new MerryPhotoOverlay(context);
        overlayView.registerMerryPhotoOverlayListener(this);

        // set overView
        overlayView.setEnableCollect(isEnabledCollect);
        overlayView.setDismissOnCollect(isDismissOnCollect);
        overlayView.setEnableSimilarImages(isEnableSimilarImages);

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

    @Override
    public void onImageChange(int position) {

        final MerryPhotoData merryPhotoData = getData()[position];
        String url = merryPhotoData.url;
        overlayView.setShareContext(url);

        overlayView.setDescription(merryPhotoData.summary);
        overlayView.setTitleText(merryPhotoData.title);

        int summaryColor = Color.WHITE;
        int titleColor = Color.WHITE;

        // is hide sharebutton
        overlayView.setHideShareButton(isHideShareButton());
        overlayView.setHideCloseButton(isHideCloseButton());

        overlayView.setPagerText((position + 1) + " / " + getData().length);
        if (merryPhotoData.titleColor != 0) {

            titleColor = merryPhotoData.titleColor;
        }
        overlayView.setTitleTextColor(titleColor);
        if (merryPhotoData.summaryColor != 0) {
            summaryColor = merryPhotoData.summaryColor;
        }
        overlayView.setDescriptionTextColor(summaryColor);

        overlayView.setIsCollect(merryPhotoData.isCollected);


        WritableMap writableMap = Arguments.createMap();
        writableMap.putString("title", merryPhotoData.title);
        writableMap.putString("summary", merryPhotoData.summary);
        writableMap.putInt("summaryColor", merryPhotoData.summaryColor);
        writableMap.putInt("titleColor", merryPhotoData.titleColor);
        writableMap.putMap("source", Utils.toWritableMap(merryPhotoData.source));
        writableMap.putBoolean("isCollected", merryPhotoData.isCollected);

        // onChange event from js side
        WritableMap map = Arguments.createMap();
        map.putMap("photo", writableMap);
        map.putInt("index", position);

        this.merryPhotoData = merryPhotoData;
        this.position = position;
        onNavigateToPhoto(map);
    }

    @Override
    public void onShareClicked() {
        WritableMap map = createMerryPhotoDataMap();
        onShare(map);
    }

    @Override
    public void onCollectClicked() {
        this.merryPhotoData.isCollected = true;
        WritableMap map = createMerryPhotoDataMap();
        onCollect(map);
    }

    @Override
    public void onUnCollectClicked() {
        this.merryPhotoData.isCollected = false;
        WritableMap map = createMerryPhotoDataMap();
        onUncollect(map);
    }

    @Override
    public void onSimilarClicked() {
        WritableMap map = createMerryPhotoDataMap();
        onSimilarImages(map);
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

    /**
     * on share
     */
    protected void onShare(WritableMap map) {
        final Context context = getContext();
        if (context instanceof ReactContext) {
            ((ReactContext) context).getJSModule(RCTEventEmitter.class).receiveEvent(getId(), "onShare", map);
        }
    }

    /**
     * on collect
     */
    protected void onCollect(WritableMap map) {
        final Context context = getContext();
        if (context instanceof ReactContext) {
            ((ReactContext) context).getJSModule(RCTEventEmitter.class).receiveEvent(getId(), "onCollect", map);
        }
    }

    /**
     * on un collect
     */
    protected void onUncollect(WritableMap map) {
        final Context context = getContext();
        if (context instanceof ReactContext) {
            ((ReactContext) context).getJSModule(RCTEventEmitter.class).receiveEvent(getId(), "onUncollect", map);
        }
    }

    /**
     * on similar images
     */
    protected void onSimilarImages(WritableMap map) {
        final Context context = getContext();
        if (context instanceof ReactContext) {
            ((ReactContext) context).getJSModule(RCTEventEmitter.class).receiveEvent(getId(), "onSimilarImages", map);
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
                .setProgressBarImage(R.drawable.progress_bar_circle);
    }

    private WritableMap createMerryPhotoDataMap() {
        WritableMap writableMap = Arguments.createMap();
        writableMap.putString("title", merryPhotoData.title);
        writableMap.putString("summary", merryPhotoData.summary);
        writableMap.putInt("summaryColor", merryPhotoData.summaryColor);
        writableMap.putInt("titleColor", merryPhotoData.titleColor);
        writableMap.putMap("source", Utils.toWritableMap(merryPhotoData.source));
        writableMap.putBoolean("isCollected", merryPhotoData.isCollected);

        WritableMap map = Arguments.createMap();
        map.putMap("position", writableMap);
        map.putInt("index", position);
        return map;
    }

    public void setEnableCollect(Boolean isEnabledCollect) {
        this.isEnabledCollect = isEnabledCollect;
    }

    public void setDismissOnCollect(Boolean isDismissOnCollect) {
        this.isDismissOnCollect = isDismissOnCollect;
    }

    public void setEnableSimilarImages(Boolean isEnableSimilarImages) {
        this.isEnableSimilarImages = isEnableSimilarImages;
    }

    public void setShowProjectDetailButton(Boolean isShowProjectDetailButton) {
        this.isShowProjectDetailButton = isShowProjectDetailButton;
    }
}

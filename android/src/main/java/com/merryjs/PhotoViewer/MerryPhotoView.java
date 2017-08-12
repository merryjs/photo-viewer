package com.merryjs.PhotoViewer;

import android.content.Context;
import android.graphics.Color;
import android.view.View;

import com.facebook.drawee.generic.GenericDraweeHierarchyBuilder;
import com.facebook.imagepipeline.request.ImageRequest;
import com.facebook.imagepipeline.request.ImageRequestBuilder;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.merryjs.PhotoViewer.MerryPhotoData;
import com.merryjs.PhotoViewer.MerryPhotoOverlay;
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


	public MerryPhotoView(Context context) {
		super(context);
	}


	protected ImageViewer.Builder init() {
		final Context context = getContext();
		overlayView = new MerryPhotoOverlay(context);
		builder = new ImageViewer.Builder(context, getData())
				.setFormatter(new ImageViewer.Formatter<MerryPhotoData>() {
					@Override
					public String format(MerryPhotoData o) {
						return o.source.getString("uri");
					}
				})
				.setOnDismissListener(getDismissListener());

		builder.setOverlayView(overlayView);
		builder.setImageChangeListener(getImageChangeListener());
		builder.setStartPosition(getInitial());
		builder.hideStatusBar(isHideStatusBar());
		builder.setCustomImageRequestBuilder(getLocalImage());
		builder.setCustomDraweeHierarchyBuilder(progressBarDrawableBuilder());

		return builder;
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
//                if (options.titlePagerColor != null) {
//                    overlayView.setPagerTextColor(options.titlePagerColor);
//                }
//
				overlayView.setPagerText((position + 1) + " / " + getData().length);
//
				if (merryPhotoData.titleColor != 0) {

					titleColor = merryPhotoData.titleColor;
				}
				overlayView.setTitleTextColor(titleColor);
				if (merryPhotoData.summaryColor != 0) {
					summaryColor = merryPhotoData.summaryColor;
				}
				overlayView.setDescriptionTextColor(summaryColor);


				// onChange event from js side
//				WritableMap map = Arguments.createMap();
//
//				map.putString("currentPhoto", "");
//
//				onNavigateToPhoto(map);
//
//                if (options.shareTextColor != null) {
//                    overlayView.setShareTextColor(options.shareTextColor);
//                }
			}
		};
	}

	/**
	 * on dismiss
	 */
	protected void onDialogDismiss() {
		final Context context = getContext();
		if (context instanceof ReactContext) {
			((ReactContext) context).getJSModule(RCTEventEmitter.class).receiveEvent(getId(), "onDismiss", null);
		}
	}

	/**
	 * on photo change
	 *
	 * @param merryPhotoData
	 */
//	protected void onNavigateToPhoto(WritableMap map) {
//		final Context context = getContext();
//		if (context instanceof ReactContext) {
//			((ReactContext) context).getJSModule(RCTEventEmitter.class).receiveEvent(getId(), "onNavigateToPhoto", map);
//		}
//	}

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

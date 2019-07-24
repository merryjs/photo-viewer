package com.stfalcon.frescoimageviewer;

import android.content.Context;
import android.graphics.drawable.Animatable;
import android.net.Uri;
import android.view.View;
import android.view.ViewGroup;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.drawee.backends.pipeline.PipelineDraweeControllerBuilder;
import com.facebook.drawee.controller.BaseControllerListener;
import com.facebook.drawee.drawable.ScalingUtils;
import com.facebook.drawee.generic.GenericDraweeHierarchyBuilder;
import com.facebook.imagepipeline.image.ImageInfo;
import com.facebook.imagepipeline.request.ImageRequestBuilder;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.views.imagehelper.ImageSource;

import com.merryjs.PhotoViewer.MerryPhotoData;
import com.stfalcon.frescoimageviewer.adapter.RecyclingPagerAdapter;
import com.stfalcon.frescoimageviewer.adapter.ViewHolder;
import com.stfalcon.frescoimageviewer.drawee.ZoomableDraweeView;

import java.util.HashSet;

import me.relex.photodraweeview.OnScaleChangeListener;

import com.facebook.react.modules.fresco.ReactNetworkImageRequest;
import com.facebook.imagepipeline.request.ImageRequest;

/*
 * Created by troy379 on 07.12.16.
 */
class ImageViewerAdapter
		extends RecyclingPagerAdapter<ImageViewerAdapter.ImageViewHolder> {

	private Context context;
	private ImageViewer.DataSet<?> dataSet;
	private HashSet<ImageViewHolder> holders;
	private ImageRequestBuilder imageRequestBuilder;
	private GenericDraweeHierarchyBuilder hierarchyBuilder;
	private boolean isZoomingAllowed;

	ImageViewerAdapter(Context context, ImageViewer.DataSet<?> dataSet,
					   ImageRequestBuilder imageRequestBuilder,
					   GenericDraweeHierarchyBuilder hierarchyBuilder,
					   boolean isZoomingAllowed) {
		this.context = context;
		this.dataSet = dataSet;
		this.holders = new HashSet<>();
		this.imageRequestBuilder = imageRequestBuilder;
		this.hierarchyBuilder = hierarchyBuilder;
		this.isZoomingAllowed = isZoomingAllowed;
	}

	@Override
	public ImageViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
		ZoomableDraweeView drawee = new ZoomableDraweeView(context);
		drawee.setEnabled(isZoomingAllowed);

		ImageViewHolder holder = new ImageViewHolder(drawee);
		holders.add(holder);

		return holder;
	}

	@Override
	public void onBindViewHolder(ImageViewHolder holder, int position) {
		holder.bind(position);
	}

	@Override
	public int getItemCount() {
		return dataSet.getData().size();
	}


	boolean isScaled(int index) {
		for (ImageViewHolder holder : holders) {
			if (holder.position == index) {
				return holder.isScaled;
			}
		}
		return false;
	}

	void resetScale(int index) {
		for (ImageViewHolder holder : holders) {
			if (holder.position == index) {
				holder.resetScale();
				break;
			}
		}
	}

	String getUrl(int index) {
		return dataSet.format(index);
	}

	private BaseControllerListener<ImageInfo>
	getDraweeControllerListener(final ZoomableDraweeView drawee) {
		return new BaseControllerListener<ImageInfo>() {
			@Override
			public void onFinalImageSet(String id, ImageInfo imageInfo, Animatable animatable) {
				super.onFinalImageSet(id, imageInfo, animatable);
				if (imageInfo == null) {
					return;
				}
				drawee.update(imageInfo.getWidth(), imageInfo.getHeight());
			}
		};
	}

	public Context getContext() {
		return context;
	}

	class ImageViewHolder extends ViewHolder implements OnScaleChangeListener {

		private int position = -1;
		private ZoomableDraweeView drawee;
		private boolean isScaled;

		ImageViewHolder(View itemView) {
			super(itemView);
			drawee = (ZoomableDraweeView) itemView;
		}

		void bind(int position) {
			this.position = position;

			tryToSetHierarchy();
			ReadableMap mHeaders = null;

			try {
				MerryPhotoData current = ((MerryPhotoData) dataSet.getData().get(position));
				if (current.source != null) {


					if (current.source.hasKey("headers")) {
						mHeaders = current.source.getMap("headers");
					}

				}
			} catch (Exception e) {
//				Log.e("PHOTO_VIEWER: ", e.toString());
			}


			setController(dataSet.format(position), mHeaders);

			drawee.setOnScaleChangeListener(this);
		}

		@Override
		public void onScaleChange(float scaleFactor, float focusX, float focusY) {
			isScaled = drawee.getScale() > 1.0f;
		}

		void resetScale() {
			drawee.setScale(1.0f, true);
		}

		private void tryToSetHierarchy() {
			if (hierarchyBuilder != null) {
				hierarchyBuilder.setActualImageScaleType(ScalingUtils.ScaleType.FIT_CENTER);
				drawee.setHierarchy(hierarchyBuilder.build());
			}
		}

		private void setController(String url, ReadableMap headers) {
			PipelineDraweeControllerBuilder controllerBuilder = Fresco.newDraweeControllerBuilder();
//			controllerBuilder.setUri(url);
			controllerBuilder.setOldController(drawee.getController());
			controllerBuilder.setControllerListener(getDraweeControllerListener(drawee));
			controllerBuilder.setAutoPlayAnimations(true);
			if (imageRequestBuilder != null) {
				imageRequestBuilder.setSource(Uri.parse(url));
				controllerBuilder.setImageRequest(imageRequestBuilder.build());
			}
//			support load local image just like React Native do

			ImageSource imageSource = new ImageSource(getContext(), url);
			ImageRequestBuilder imageRequestBuilder1 = ImageRequestBuilder.newBuilderWithSource(imageSource.getUri());
//			support headers
			ImageRequest imageRequest = ReactNetworkImageRequest.fromBuilderWithHeaders(imageRequestBuilder1, headers);

			controllerBuilder.setImageRequest(imageRequest);


			drawee.setController(controllerBuilder.build());
		}

	}
}


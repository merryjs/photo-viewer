package com.merryjs.PhotoViewer;


import android.content.Context;
import android.util.Log;

import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;

import com.facebook.react.uimanager.annotations.ReactProp;
import com.google.gson.Gson;
import com.merryjs.PhotoViewer.MerryPhotoData;

import java.util.Map;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

public class MerryPhotoViewManager extends SimpleViewManager<MerryPhotoView> {
	public static final String REACT_CLASS = "MerryPhotoView";
	private Context context;

	@Override
	public String getName() {
		// Tell React the name of the module
		// https://facebook.github.io/react-native/docs/native-components-android.html#1-create-the-viewmanager-subclass
		return REACT_CLASS;
	}

	@Override
	public MerryPhotoView createViewInstance(ThemedReactContext context) {
		context = context;
		// Create a view here
		// https://facebook.github.io/react-native/docs/native-components-android.html#2-implement-method-createviewinstance
		return new MerryPhotoView(context);
	}

	@Override
	public void onDropViewInstance(MerryPhotoView view) {
		super.onDropViewInstance(view);
	}

	@Override
	protected void onAfterUpdateTransaction(MerryPhotoView merryPhotoView) {
		super.onAfterUpdateTransaction(merryPhotoView);
		merryPhotoView.init().show();
	}

	@ReactProp(name = "data")
	public void setData(MerryPhotoView merryPhotoView, @Nonnull ReadableArray prop) {
//        this.getPhotos(prop);
		MerryPhotoData[] arrayList = new Gson().fromJson(prop.toString(), MerryPhotoData[].class);
		merryPhotoView.setData(arrayList);
		Log.e("", prop.toString());
	}

	@ReactProp(name = "initial")
	public void setInitial(MerryPhotoView merryPhotoView, int prop) {

		merryPhotoView.setInitial(prop);

	}

	@ReactProp(name = "hideStatusBar")
	public void setHideStatusBar(MerryPhotoView merryPhotoView, Boolean prop) {
		merryPhotoView.setHideStatusBar(prop);
	}

	@ReactProp(name = "shareText")
	public void setShareText(MerryPhotoView merryPhotoView, String prop) {
		merryPhotoView.setShareText(prop);
	}

	@Nullable
	@Override
	public Map<String, Object> getExportedCustomDirectEventTypeConstants() {
		return MapBuilder.<String, Object>builder()
				// .put("onNavigateToPhoto", MapBuilder.of("registrationName", "onNavigateToPhoto"))
				.put("onDismiss", MapBuilder.of("registrationName", "onDismiss")).build();
	}
}

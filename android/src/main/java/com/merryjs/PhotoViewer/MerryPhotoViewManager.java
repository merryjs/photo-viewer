
package com.merryjs.PhotoViewer;


import android.content.Context;
import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;

import com.facebook.react.uimanager.annotations.ReactProp;
import com.merryjs.PhotoViewer.MerryPhotoData;

import org.json.JSONArray;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import com.merryjs.PhotoViewer.Utils;

public class MerryPhotoViewManager extends SimpleViewManager<MerryPhotoView> {
    public static final String REACT_CLASS = "MerryPhotoView";
    private Context context;

    @Override
    public String getName() {

        return REACT_CLASS;
    }

    @Override
    public MerryPhotoView createViewInstance(ThemedReactContext context) {
        context = context;

        return new MerryPhotoView(context);
    }

    @Override
    public void onDropViewInstance(MerryPhotoView view) {
        super.onDropViewInstance(view);
    }

    @Override
    protected void onAfterUpdateTransaction(MerryPhotoView merryPhotoView) {
        super.onAfterUpdateTransaction(merryPhotoView);
        merryPhotoView.init();
    }

    @ReactProp(name = "data")
    public void setData(MerryPhotoView merryPhotoView, @Nonnull ReadableArray prop) {

        MerryPhotoData[] merryPhotoDatas = new MerryPhotoData[]{};

        ArrayList<MerryPhotoData> list = new ArrayList<>();

        for (int i = 0; i < prop.size(); i++) {


            try {
                MerryPhotoData merryPhotoData = new MerryPhotoData() {
                };
                ReadableMap rm = prop.getMap(i);

                if (rm.hasKey("source")) {
                    merryPhotoData.source = rm.getMap("source");

                }
                if (rm.hasKey("summary")) {
                    merryPhotoData.summary = rm.getString("summary");

                }
                if (rm.hasKey("summaryColor")) {
                    merryPhotoData.summaryColor = rm.getInt("summaryColor");

                }
                if (rm.hasKey("title")) {
                    merryPhotoData.title = rm.getString("title");

                }
                if (rm.hasKey("titleColor")) {
                    merryPhotoData.titleColor = rm.getInt("titleColor");
                }
                list.add(merryPhotoData);

            } catch (Exception e) {
                Log.e("PHOTO_VIEWER: ", e.toString());
            }


        }

        merryPhotoView.setData(list.toArray(merryPhotoDatas));
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

    @ReactProp(name = "hideShareButton", defaultBoolean = false)
    public void setHideShareButton(MerryPhotoView merryPhotoView, Boolean prop) {
        merryPhotoView.setHideShareButton(prop);
    }

    @ReactProp(name = "hideCloseButton", defaultBoolean = false)
    public void setHideCloseButton(MerryPhotoView merryPhotoView, Boolean prop) {
        merryPhotoView.setHideCloseButton(prop);
    }

    @ReactProp(name = "hideTitle", defaultBoolean = false)
    public void setHideTitle(MerryPhotoView merryPhotoView, Boolean prop) {
        merryPhotoView.setHideTitle(prop);
    }

    @Nullable
    @Override
    public Map<String, Object> getExportedCustomDirectEventTypeConstants() {
        return MapBuilder.<String, Object>builder()
                .put("onChange", MapBuilder.of("registrationName", "onChange"))
                .put("onDismiss", MapBuilder.of("registrationName", "onDismiss")).build();
    }
}

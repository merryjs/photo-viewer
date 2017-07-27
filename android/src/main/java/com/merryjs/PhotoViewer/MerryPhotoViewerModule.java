//  Created by react-native-create-bridge

package com.merryjs.PhotoViewer;

import android.app.Activity;
import android.content.Intent;
import android.support.annotation.Nullable;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.google.gson.Gson;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public class MerryPhotoViewerModule extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "MerryPhotoViewer";
    private static ReactApplicationContext reactContext = null;

    private Intent mIntent;
    private int PHOTO_VIEWER_CODE = 1;

    private static final String E_ACTIVITY_DOES_NOT_EXIST = "E_ACTIVITY_DOES_NOT_EXIST";
    private static final String E_INVALID_OPTIONS = "E_INVALID_OPTIONS";
    private static final String E_FAILED_TO_SHOW_PHOTO_VIEWER = "FAILED_TO_SHOW_PHOTO_VIEWER";

    public MerryPhotoViewerModule(ReactApplicationContext context) {
        // Pass in the context to the constructor and save it so you can emit events
        // https://facebook.github.io/react-native/docs/native-modules-android.html#the-toast-module
        super(context);

        reactContext = context;

    }

    @Override
    public String getName() {
        // Tell React the name of the module
        // https://facebook.github.io/react-native/docs/native-modules-android.html#the-toast-module
        return REACT_CLASS;
    }

    @ReactMethod
    public void show(ReadableMap options, Promise promise) {


        Activity currentActivity = getCurrentActivity();
        if (currentActivity == null) {
            promise.reject(E_ACTIVITY_DOES_NOT_EXIST, "Activity doesn't exist");
            return;
        }

        mIntent = new Intent(currentActivity, MerryPhotoViewActivity.class);

        JSONObject jsonObject = Utils.readableMapToJson(options);

        if (jsonObject == null) {
            promise.reject(E_INVALID_OPTIONS, "Invalid options, please check your configuration");
            return;
        }
        try {
            mIntent.putExtra("options", jsonObject.toString());
            currentActivity.startActivityForResult(mIntent, PHOTO_VIEWER_CODE);
            promise.resolve("");
        } catch (Exception e) {
            promise.reject(E_FAILED_TO_SHOW_PHOTO_VIEWER, e);
        }
    }

    @ReactMethod
    public void hide() {
        if (mIntent != null && reactContext.getCurrentActivity() != null) {
            reactContext.getCurrentActivity().finishActivity(PHOTO_VIEWER_CODE);
        }
    }


}

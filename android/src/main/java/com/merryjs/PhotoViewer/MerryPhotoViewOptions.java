package com.merryjs.PhotoViewer;
import java.io.Serializable;

@SuppressWarnings("serial") //With this annotation we are going to hide compiler warnings
public class MerryPhotoViewOptions {

    public MerryPhotoData[] data;
    public String titlePagerColor;
    public String shareTextColor;
    public String shareText;

    public String backgroundColor;
    public int initial;
    public boolean hideStatusBar;
    public boolean swipeToDismiss;
    public boolean zooming;
}

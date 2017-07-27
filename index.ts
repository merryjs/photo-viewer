import { NativeModules, processColor, Platform } from "react-native";

const { MerryPhotoViewer } = NativeModules;
/**
 * Photo data
 */
export interface Photo {
  url: string;
  title?: string;
  summary?: string;
  titleColor?: string | number;
  summaryColor?: string | number;
}

export interface PhotoViewerOptions {
  /**
	 * Pictures for view
	 */
  data: Photo[];
  /**
	 * Start position
	 */
  initial: number;
  /**
	 * Set overlay background color
	 */
  backgroundColor?: string;
  /**
	 * Android only
	 */
  hideStatusBar: boolean;
  /**
	 * Android only
	 */
  swipeToDismiss?: boolean;
  /**
	 * Android only
	 */
  zooming?: boolean;
  /**
	 * Android only
	 * Set share text the default text is SHARE
	 */
  shareText?: string;
}
const isIos = Platform.OS === "ios";

/**
 * Handle UIColor conversions for ios
 * @param options PhotoViewerOptions
 */
const processor = (options: PhotoViewerOptions) => {
  if (options && options.data && options.data.length) {

    options.data = options.data.map(o => {
      if (typeof o.summaryColor === "string") {
        o.summaryColor = processColor(o.summaryColor);
      }
      if (typeof o.titleColor === "string") {
        o.titleColor = processColor(o.titleColor);
      }
      return o;
		});

  }
  return options;
};
/**
 * Photo viewer
 */
const photoViewer = {
  /**
	 * Display the Photo Viewer
	 * @param options PhotoViewerOptions
	 */
  show(options: PhotoViewerOptions): Promise<void> {
    let o = { ...options };
    // IOS color process
    if (isIos) {
      o = processor(o);
    }
    return MerryPhotoViewer.show(o);
  },
  /**
	 * Hide Photo Viewer
	 */
  hide() {
    MerryPhotoViewer.hide();
  }
};

export default photoViewer;

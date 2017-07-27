import { NativeModules } from "react-native";

const { MerryPhotoViewer } = NativeModules;

export interface Photo {
  url: string;
  title?: string;
  summary?: string;
  titleColor?: string;
  summaryColor?: string;
}

export interface PhotoViewerOptions {
  data: string[];
	initial: number;
  backgroundColor?: string;
  /**
	 * android only
	 */
  hideStatusBar: boolean;
  /**
	 * android only
	 */
  swipeToDismiss?: boolean;
  /**
	 * android only
	 */
  zooming?: boolean;
  /**
	 * android only
	 */
  shareText?: string;
}
/**
 * photo viewer
 */
const photoViewer = {
  show(options: PhotoViewerOptions): Promise<void> {
    return MerryPhotoViewer.show(options);
  },
  hide() {
    MerryPhotoViewer.hide();
  }
};

export default photoViewer;

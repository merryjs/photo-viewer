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
  hideStatusBar: boolean;
  // android only
  swipeToDismiss?: boolean;
  zooming?: boolean;
  // not support #ddd should be "#000000"
  backgroundColor?: string;
  // default share
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

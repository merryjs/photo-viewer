import { NativeModules } from "react-native";

const { MerryPhotoViewer } = NativeModules;

export interface Photo {
  url: string;
  title: string;
  summary: string;
}

export interface PhotoViewerOptions {
  data: string[];
  titleColor?: string;
  summaryColor?: string;
}

/**
 * photo viewer
 */
const photoViewer = {
  config: (options: PhotoViewerOptions) => {
    MerryPhotoViewer.config(options);
  },
  show: (photo?: number) => {
    MerryPhotoViewer.show(photo);
  },
  hide: () => {
    MerryPhotoViewer.hide();
  }
};

export default photoViewer;

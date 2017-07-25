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
  init: (options: PhotoViewerOptions) => {
    MerryPhotoViewer.config(options);
    return {
      show: (photo?: number) => {
        MerryPhotoViewer.show(photo);
      },
      hide: () => {
        MerryPhotoViewer.hide();
      }
    };
  }
};

export default photoViewer;

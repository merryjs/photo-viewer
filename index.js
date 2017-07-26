import { NativeModules } from "react-native";
const { MerryPhotoViewer } = NativeModules;
/**
 * photo viewer
 */
const photoViewer = {
    config: (options) => {
        MerryPhotoViewer.config(options);
    },
    show: (photo) => {
        MerryPhotoViewer.show(photo);
    },
    hide: () => {
        MerryPhotoViewer.hide();
    }
};
export default photoViewer;

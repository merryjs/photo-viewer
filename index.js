import { NativeModules } from "react-native";
const { MerryPhotoViewer } = NativeModules;
/**
 * photo viewer
 */
const photoViewer = {
    init: (options) => {
        MerryPhotoViewer.config(options);
        return {
            show: (photo) => {
                MerryPhotoViewer.show(photo);
            },
            hide: () => {
                MerryPhotoViewer.hide();
            }
        };
    }
};
export default photoViewer;

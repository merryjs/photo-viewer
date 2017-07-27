import { NativeModules } from "react-native";
const { MerryPhotoViewer } = NativeModules;
/**
 * photo viewer
 */
const photoViewer = {
    show(options) {
        return MerryPhotoViewer.show(options);
    },
    hide() {
        MerryPhotoViewer.hide();
    }
};
export default photoViewer;

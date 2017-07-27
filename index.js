import { NativeModules, processColor, Platform } from "react-native";
const { MerryPhotoViewer } = NativeModules;
const isIos = Platform.OS === "ios";
/**
 * Handle UIColor conversions for ios
 * @param options PhotoViewerOptions
 */
const processor = (options) => {
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
    show(options) {
        let o = Object.assign({}, options);
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

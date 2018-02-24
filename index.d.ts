/// <reference types="react" />
import * as React from "react";
import { ImageURISource } from "react-native";
import * as PropTypes from "prop-types";
/**
 * Photo data
 */
export interface Photo {
    /**
      * Same as React Native Image source but not support Array
      * @see https://github.com/facebook/react-native/blob/master/Libraries/Image/ImageSourcePropType.js
      */
    source: ImageURISource;
    title?: string;
    summary?: string;
    titleColor?: string | number;
    summaryColor?: string | number;
}
export interface MerryPhotoViewPorps {
    /**
       * Photos for view
       */
    data: Photo[];
    /**
       * Start position
       */
    initial: number;
    /**
       * Hide status bar
       */
    hideStatusBar?: boolean;
    /**
       * Hide close button
       */
    hideCloseButton?: boolean;
    /**
     * Hide share button
     */
    hideShareButton?: boolean;
    /**
       * **Android only**
       * Set share text the default text is `SHARE`
       */
    shareText?: string;
    /**
       * Display or hide the viewer
       */
    visible: boolean;
    /**
       * When viewer has dismissed but you still needs to update the visible state
       */
    onDismiss: () => void;
}
declare class MerryPhotoView extends React.Component<MerryPhotoViewPorps, any> {
    static propTypes: {
        data: PropTypes.Validator<any>;
        visible: PropTypes.Requireable<any>;
        initial: PropTypes.Validator<any>;
        hideStatusBar: PropTypes.Requireable<any>;
        hideCloseButton: PropTypes.Requireable<any>;
        hideShareButton: PropTypes.Requireable<any>;
        onDismiss: PropTypes.Validator<any>;
        shareText: PropTypes.Requireable<any>;
    };
    static defaultProps: {
        visible: boolean;
    };
    /**
       * Handle UIColor conversions
       * @param data Photo[]
       */
    processor: (data: Photo[]) => Photo[];
    render(): JSX.Element | null;
}
export default MerryPhotoView;

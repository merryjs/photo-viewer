/// <reference types="react" />
import * as React from "react";
import * as PropTypes from "prop-types";
/**
 * Photo data
 */
export interface Photo {
    /**
       * Photo url support both local path and remote url:
       * - **remote url** eg: http://path/to/photo.png if you want support gif make sure your url contains the `.gif` extension.
       * - **local image** you need use `resolveAssetSource`
  
          ```js
  
                      const resolveAssetSource = require("react-native/Libraries/Image/resolveAssetSource");
                      const cat = require("./cat-2575694_1920.jpg");
                      const localPhotos = [{
                              // get uri
                              url: resolveAssetSource(cat).uri,
                              title: "Local image"
                      }]
          ```
       * - **for photo library image**:  when you get an image object it should contains the uri property, just use it directly
  
          ```js
  
                      const localPhotos = [{
                          // get uri
                          url: imageObjectFromPhotoLibrary.uri,
                          title: "Photo library image"
                      }]
  
          ```
       */
    url: string;
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
export default class MerryPhotoView extends React.Component<MerryPhotoViewPorps, any> {
    static propTypes: {
        data: PropTypes.Validator<any>;
        visible: PropTypes.Requireable<any>;
        initial: PropTypes.Validator<any>;
        hideStatusBar: PropTypes.Requireable<any>;
        hideCloseButton: PropTypes.Requireable<any>;
        hideShareButton: PropTypes.Requireable<any>;
        onDismiss: PropTypes.Validator<any>;
        onChange: PropTypes.Requireable<any>;
    };
    static defaultProps: {
        visible: boolean;
    };
    componentDidMount(): void;
    onDismiss(): void;
    render(): JSX.Element | null;
}

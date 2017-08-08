import * as React from "react";
import {
  requireNativeComponent,
  processColor,
  NativeSyntheticEvent
} from "react-native";
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

export interface PhotoViewerPorps {
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
	 * Android only
	 * Set share text the default text is SHARE
	 */
  shareText?: string;
  /**
	 * Display or hide the viewer
	 */
  visible: boolean;
  /**
	 * When a photo has changed not implemented in Android yet. useless
	 */
  onChange?: (current: object) => void;
  /**
	 * When viewer has dismissed but you still needs to update the visible state
	 */
  onDismiss: () => void;
}

/**
 * Handle UIColor conversions
 * @param data Photo[]
 */
const processor = (data: Photo[]) => {
  if (data && data.length) {
    return data.map(o => {
      if (typeof o.summaryColor === "string") {
        o.summaryColor = processColor(o.summaryColor);
      }
      if (typeof o.titleColor === "string") {
        o.titleColor = processColor(o.titleColor);
      }
      return o;
    });
  }
  return data;
};
//  Created by react-native-create-bridge

const RNMerryPhotoView = requireNativeComponent(
  "MerryPhotoView",
  MerryPhotoView,
  {
    nativeOnly: {
      onNavigateToPhoto: true
    }
  }
);

export default class MerryPhotoView extends React.Component<
  PhotoViewerPorps,
  any
> {
  static propTypes = {
    data: PropTypes.arrayOf(
      PropTypes.shape({
        url: PropTypes.string.isRequired,
        title: PropTypes.string,
        summary: PropTypes.string,
        titleColor: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
        summaryColor: PropTypes.oneOfType([PropTypes.string, PropTypes.number])
      })
    ).isRequired,
    visible: PropTypes.bool,
    initial: PropTypes.number.isRequired,
    hideStatusBar: PropTypes.bool,
    // IOS only
    hideCloseButton: PropTypes.bool,
    // IOS only
    hideShareButton: PropTypes.bool,
    onDismiss: PropTypes.func.isRequired,
    onChange: PropTypes.func
  };

  static defaultProps = {
    visible: false
  };

  componentDidMount() {}
  onChange(e: NativeSyntheticEvent<any>) {
    if (this.props.onChange) {
      this.props.onChange(e.nativeEvent.currentPhoto);
    }
  }
  onDismiss() {}
  render() {
    const { visible, onChange, data, ...props } = this.props;

    if (visible === false) {
      return null;
    }
    const transformData = processor(data);

    return (
      <RNMerryPhotoView
        {...props}
        data={transformData}
        onNavigateToPhoto={(e: NativeSyntheticEvent<any>) => this.onChange(e)}
      />
    );
  }
}

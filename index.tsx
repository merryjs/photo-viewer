import * as React from "react";
import {
  requireNativeComponent,
  processColor,
  NativeSyntheticEvent,
  ImageURISource,
  Platform
} from "react-native";
import * as PropTypes from "prop-types";
const resolveAssetSource = require("react-native/Libraries/Image/resolveAssetSource");
const ImageSourcePropType = require("react-native/Libraries/Image/ImageSourcePropType");

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

var RNMerryPhotoView = requireNativeComponent("MerryPhotoView", MerryPhotoView);
class MerryPhotoView extends React.Component<MerryPhotoViewPorps, any> {
  static propTypes = {
    data: PropTypes.arrayOf(
      PropTypes.shape({
        source:
          Platform.OS === "ios"
            ? ImageSourcePropType
            : PropTypes.oneOfType([
                PropTypes.shape({
                  uri: PropTypes.string,
                  headers: PropTypes.objectOf(PropTypes.string)
                }),
                // Opaque type returned by require('./image.jpg')
                PropTypes.number,
                // Multiple sources
                PropTypes.arrayOf(
                  PropTypes.shape({
                    uri: PropTypes.string,
                    width: PropTypes.number,
                    height: PropTypes.number
                  })
                )
              ]),
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
    // onChange: PropTypes.func,
    shareText: PropTypes.string
  };

  static defaultProps = {
    visible: false
  };

  /**
	 * Handle UIColor conversions
	 * @param data Photo[]
	 */
  processor = (data: Photo[]) => {
    if (data && data.length) {
      return data.map(o => {
        const d = { ...o };
        if (typeof o.summaryColor === "string") {
          d.summaryColor = processColor(o.summaryColor);
        }
        if (typeof o.titleColor === "string") {
          d.titleColor = processColor(o.titleColor);
        }
        // resolve assets
        d.source = resolveAssetSource(o.source);
        return d;
      });
    }
    return data;
  };

  render() {
    // nothing
    if (this.props.visible === false) {
      return null;
    }

    const { visible, data, initial, ...props } = this.props;

    const dataCopy = [...data];

    const transformData = this.processor(dataCopy);

		// initial
    let startPosition = initial;
    if (initial < 0) {
      startPosition = 0;
    }
    if (initial > dataCopy.length) {
      startPosition = dataCopy.length;
    }
    return (
      <RNMerryPhotoView
        {...props}
        initial={startPosition}
        data={transformData}
      />
    );
  }
}

export default MerryPhotoView;

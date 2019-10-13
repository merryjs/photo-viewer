import * as React from "react";
import {
  requireNativeComponent,
  processColor,
  NativeSyntheticEvent,
  ImageURISource,
  Platform,
  View,
  ViewProperties
} from "react-native";
import * as PropTypes from "prop-types";
const resolveAssetSource = require("react-native/Libraries/Image/resolveAssetSource");
const ImageSourcePropType = require("react-native/Libraries/Image/ImageSource");

/**
 * Photo data
 */
export interface Photo {
  /**
   * Same as React Native Image source but not support Array
   * @see https://github.com/facebook/react-native/blob/master/Libraries/Image/ImageSource.js
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
  onChange?: (
    data: {
      index: number;
      photo: Photo;
    }
  ) => void;
  enableCollect: boolean;
  onCollect?: (
    data: {
      index: number;
      photo: Photo;
    }
  ) => void;
  onUncollect?: (
    data: {
      index: number;
      photo: Photo;
    }
  ) => void;
  onShare?: (
    data: {
      index: number;
      photo: Photo;
    }
  ) => void;
  enableSimilarImages: boolean;
  onSimilarImages?: (
    data: {
      index: number;
      photo: Photo;
    }
  ) => void;
}

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
    hideCloseButton: PropTypes.bool,
    hideShareButton: PropTypes.bool,
    onDismiss: PropTypes.func.isRequired,
    onChange: PropTypes.func,
    shareText: PropTypes.string,
    ...View.propTypes
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
  onChange = (event: any) => {
    const { onChange } = this.props;
    if (onChange) {
      const { target, ...rest } = event.nativeEvent;
      onChange(rest);
    }
  };
  onCollect = (event: any) => {
    const { onCollect } = this.props;
    if (onCollect) {
      const { target, ...rest } = event.nativeEvent;
      onCollect(rest);
    }
  };
  onUncollect = (event: any) => {
    const { onUncollect } = this.props;
    if (onUncollect) {
      const { target, ...rest } = event.nativeEvent;
      onUncollect(rest);
    }
  };
  onShare = (event: any) => {
    const { onShare } = this.props;
    if (onShare) {
      const { target, ...rest } = event.nativeEvent;
      onShare(rest);
    }
  };
  onSimilarImages = (event: any) => {
    const { onSimilarImages } = this.props;
    if (onSimilarImages) {
      const { target, ...rest } = event.nativeEvent;
      onSimilarImages(rest);
    }
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
        {...props as any}
        initial={startPosition}
        data={transformData}
        onChange={this.onChange}
        onCollect={this.onCollect}
        onUncollect={this.onUncollect}
        onShare={this.onShare}
        onSimilarImages={this.onSimilarImages}
      />
    );
  }
}
var RNMerryPhotoView = requireNativeComponent(
  "MerryPhotoView",
  MerryPhotoView,
  {
    nativeOnly: {
      onChange: true,
      onChange: true,
      onCollect: true,
      onUncollect: true,
      onShare: true,
      onSimilarImages: true
    }
  }
);

export default MerryPhotoView;

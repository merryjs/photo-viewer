//  Created by react-native-create-bridge

import React, { Component } from "react";
import { requireNativeComponent } from "react-native";
import PropTypes from "prop-types";

const RNMerryPhotoView = requireNativeComponent(
  "MerryPhotoView",
  MerryPhotoView,
  {
    nativeOnly: {
      onNavigateToPhoto: true
    }
  }
);

export default class MerryPhotoView extends Component {
  componentDidMount() {}
  onChange(e) {
    if (this.props.onChange) {
      this.props.onChange(e.nativeEvent.currentPhoto);
    }
  }
  render() {
    if (!this.props.visible) {
      return null;
    }
    return (
      <RNMerryPhotoView
        {...this.props}
        onNavigateToPhoto={e => this.onChange(e)}
      />
    );
  }
}

MerryPhotoView.propTypes = {
  visible: PropTypes.bool,
  initial: PropTypes.number,
  hideStatusBar: PropTypes.bool,
  hideCloseButton: PropTypes.bool,
  hideShareButton: PropTypes.bool,
  onDismiss: PropTypes.func,
  onChange: PropTypes.func
};
MerryPhotoView.defaultProps = {
  visible: false
};

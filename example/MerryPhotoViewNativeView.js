//  Created by react-native-create-bridge

import React, { Component } from "react";
import { requireNativeComponent } from "react-native";
import PropTypes from "prop-types";

const RNMerryPhotoView = requireNativeComponent(
  "MerryPhotoView",
  MerryPhotoView
);

export default class MerryPhotoView extends Component {
  componentDidMount() {}
  render() {
    if (!this.props.visible) {
      return null;
    }
    return <RNMerryPhotoView {...this.props} />;
  }
}

MerryPhotoView.propTypes = {
  visible: PropTypes.bool,
  initial: PropTypes.number,
  hideStatusBar: PropTypes.bool,
  onDismiss: PropTypes.func,
  onChange: PropTypes.func
};
MerryPhotoView.defaultProps = {
  visible: false
};

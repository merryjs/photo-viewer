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
    if (!this.props.visiable) {
      return null;
    }
    return <RNMerryPhotoView {...this.props} />;
  }
}

MerryPhotoView.propTypes = {
  exampleProp: PropTypes.string,
  visiable: PropTypes.bool
};
MerryPhotoView.defaultProps = {
  visiable: false
};

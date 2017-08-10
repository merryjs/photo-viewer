import * as React from "react";
import { requireNativeComponent, processColor } from "react-native";
import * as PropTypes from "prop-types";
const resolveAssetSource = require("react-native/Libraries/Image/resolveAssetSource");
const ImageSourcePropType = require("react-native/Libraries/Image/ImageSourcePropType");
class MerryPhotoView extends React.Component {
    constructor() {
        super(...arguments);
        /**
           * Handle UIColor conversions
           * @param data Photo[]
           */
        this.processor = (data) => {
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
    }
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
        return (<RNMerryPhotoView {...props} initial={startPosition} data={transformData}/>);
    }
}
MerryPhotoView.propTypes = {
    data: PropTypes.arrayOf(PropTypes.shape({
        source: ImageSourcePropType,
        title: PropTypes.string,
        summary: PropTypes.string,
        titleColor: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
        summaryColor: PropTypes.oneOfType([PropTypes.string, PropTypes.number])
    })).isRequired,
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
MerryPhotoView.defaultProps = {
    visible: false
};
//  Created by react-native-create-bridge
var RNMerryPhotoView = requireNativeComponent("MerryPhotoView", MerryPhotoView, {
    nativeOnly: {
        onNavigateToPhoto: true
    }
});
export default MerryPhotoView;

import * as React from "react";
import { requireNativeComponent, processColor } from "react-native";
import * as PropTypes from "prop-types";
/**
 * Handle UIColor conversions
 * @param data Photo[]
 */
const processor = (data) => {
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
const RNMerryPhotoView = requireNativeComponent("MerryPhotoView", MerryPhotoView, {
    nativeOnly: {
        onNavigateToPhoto: true
    }
});
export default class MerryPhotoView extends React.Component {
    componentDidMount() { }
    onChange(e) {
        if (this.props.onChange) {
            this.props.onChange(e.nativeEvent.currentPhoto);
        }
    }
    onDismiss() { }
    render() {
        const { visible, onChange, data, ...props } = this.props;
        if (visible === false) {
            return null;
        }
        const transformData = processor(data);
        return (<RNMerryPhotoView {...props} data={transformData} onNavigateToPhoto={(e) => this.onChange(e)}/>);
    }
}
MerryPhotoView.propTypes = {
    data: PropTypes.arrayOf(PropTypes.shape({
        url: PropTypes.string.isRequired,
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

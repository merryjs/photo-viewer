/// <reference types="react" />
import * as React from "react";
import { ImageURISource, ViewProperties } from "react-native";
import * as PropTypes from "prop-types";
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
    onChange?: (data: {
        index: number;
        photo: Photo;
    }) => void;
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
        onChange: PropTypes.Requireable<any>;
        shareText: PropTypes.Requireable<any>;
    } | {
        accessibilityLabel?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        accessible?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        hitSlop?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        onAcccessibilityTap?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        onLayout?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        onMagicTap?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        pointerEvents?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        removeClippedSubviews?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        style?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        testID?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        accessibilityComponentType?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        accessibilityLiveRegion?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        collapsable?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        importantForAccessibility?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        needsOffscreenAlphaCompositing?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        renderToHardwareTextureAndroid?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        accessibilityTraits?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        shouldRasterizeIOS?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        onStartShouldSetResponder?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        onMoveShouldSetResponder?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        onResponderEnd?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        onResponderGrant?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        onResponderReject?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        onResponderMove?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        onResponderRelease?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        onResponderStart?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        onResponderTerminationRequest?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        onResponderTerminate?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        onStartShouldSetResponderCapture?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        onMoveShouldSetResponderCapture?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        onTouchStart?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        onTouchMove?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        onTouchEnd?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        onTouchCancel?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        onTouchEndCapture?: ((object: ViewProperties, key: string, componentName: string, ...rest: any[]) => Error | null) | undefined;
        data: PropTypes.Validator<any>;
        visible: PropTypes.Requireable<any>;
        initial: PropTypes.Validator<any>;
        hideStatusBar: PropTypes.Requireable<any>;
        hideCloseButton: PropTypes.Requireable<any>;
        hideShareButton: PropTypes.Requireable<any>;
        onDismiss: PropTypes.Validator<any>;
        onChange: PropTypes.Requireable<any>;
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
    onChange: (event: any) => void;
    render(): JSX.Element | null;
}
export default MerryPhotoView;

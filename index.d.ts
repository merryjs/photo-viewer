/// <reference types="react" />
import * as React from "react";
import { NativeSyntheticEvent } from "react-native";
import * as PropTypes from "prop-types";
/**
 * Photo data
 */
export interface Photo {
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
export default class MerryPhotoView extends React.Component<PhotoViewerPorps, any> {
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
    onChange(e: NativeSyntheticEvent<any>): void;
    onDismiss(): void;
    render(): JSX.Element | null;
}

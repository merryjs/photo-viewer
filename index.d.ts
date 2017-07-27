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
export interface PhotoViewerOptions {
    /**
     * Pictures for view
     */
    data: Photo[];
    /**
     * Start position
     */
    initial: number;
    /**
     * Set overlay background color
     */
    backgroundColor?: string;
    /**
       * Android only
       */
    hideStatusBar: boolean;
    /**
       * Android only
       */
    swipeToDismiss?: boolean;
    /**
       * Android only
       */
    zooming?: boolean;
    /**
       * Android only
       * Set share text the default text is SHARE
       */
    shareText?: string;
}
/**
 * Photo viewer
 */
declare const photoViewer: {
    show(options: PhotoViewerOptions): Promise<void>;
    hide(): void;
};
export default photoViewer;

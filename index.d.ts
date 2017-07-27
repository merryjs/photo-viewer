export interface Photo {
    url: string;
    title?: string;
    summary?: string;
    titleColor?: string;
    summaryColor?: string;
}
export interface PhotoViewerOptions {
    data: string[];
    initial: number;
    backgroundColor?: string;
    /**
       * android only
       */
    hideStatusBar: boolean;
    /**
       * android only
       */
    swipeToDismiss?: boolean;
    /**
       * android only
       */
    zooming?: boolean;
    /**
       * android only
       */
    shareText?: string;
}
/**
 * photo viewer
 */
declare const photoViewer: {
    show(options: PhotoViewerOptions): Promise<void>;
    hide(): void;
};
export default photoViewer;

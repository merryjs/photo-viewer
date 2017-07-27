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
    hideStatusBar: boolean;
    swipeToDismiss?: boolean;
    zooming?: boolean;
    backgroundColor?: string;
    shareText?: string;
}
/**
 * photo viewer
 */
declare const photoViewer: {
    config: (options: PhotoViewerOptions) => void;
    show: (photo?: number | undefined) => void;
    hide: () => void;
};
export default photoViewer;

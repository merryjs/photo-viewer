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
    show(options: PhotoViewerOptions): Promise<void>;
    hide(): void;
};
export default photoViewer;

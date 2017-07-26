export interface Photo {
    url: string;
    title: string;
    summary: string;
}
export interface PhotoViewerOptions {
    data: string[];
    titleColor?: string;
    summaryColor?: string;
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

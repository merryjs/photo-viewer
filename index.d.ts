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
    init: (options: PhotoViewerOptions) => {
        show: (photo?: number | undefined) => void;
        hide: () => void;
    };
};
export default photoViewer;

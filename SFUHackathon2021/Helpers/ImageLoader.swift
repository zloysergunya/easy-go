import Kingfisher

class ImageLoader {
    
    @discardableResult
    static func setImage(url: String?,
                         imgView: UIImageView,
                         side: CGFloat? = nil,
                         completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask? {
        guard let url = url else {
            return nil
        }
        
        var options: KingfisherOptionsInfo = [
            .loadDiskFileSynchronously,
            .transition(.fade(0.2)),
        ]
        
        if let side = side {
            let processor = ResizingImageProcessor(referenceSize: CGSize(width: side * UIScreen.main.scale, height: side * UIScreen.main.scale))
            options.append(.processor(processor))
        }

        return imgView.kf.setImage(with: URL(string: url), options: options, completionHandler: completionHandler)
    }
    
}

//
//  UIImageView+DownloadableImage.swift
//  RxExample
//
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIImageView {

    var downloadableImage: Binder<DownloadableImage>{
        return downloadableImageAnimated(nil)
    }

    func downloadableImageAnimated(_ transitionType:String?) -> Binder<DownloadableImage> {
        return Binder(base) { imageView, image in
            for subview in imageView.subviews {
                subview.removeFromSuperview()
            }
            switch image {
            case .content(let image):
                (imageView as UIImageView).rx.image.on(.next(image))
            case .offlinePlaceholder:
                let label = UILabel(frame: imageView.bounds)
                label.textAlignment = .center
                label.font = UIFont.systemFont(ofSize: 35)
                label.text = "⚠️"
                imageView.addSubview(label)
            }
        }
    }
}


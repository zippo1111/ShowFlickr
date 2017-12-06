//
//  ImageCollectionCell.swift
//  ShoeOsVersion
//
//  Created by Magnolia on 04.12.2017.
//  Copyright © 2017 Mangust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ImageCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var preloader: UIActivityIndicatorView!
    
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
            self.preloader.startAnimating()
        }

    }
    
    var disposeBag: DisposeBag?
    
    var downloadableImage: Observable<DownloadableImage>?{
        didSet{
            let disposeBag = DisposeBag()
            
            self.downloadableImage?
                .asDriver(onErrorJustReturn: DownloadableImage.offlinePlaceholder)
                .drive(img.rx.downloadableImageAnimated(kCATransitionFade))
                .disposed(by: disposeBag)

            DispatchQueue.main.async {
                self.preloader.stopAnimating()
            }
            
            self.disposeBag = disposeBag
        }
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        
        downloadableImage = nil
        disposeBag = nil
    }
    
    deinit {
    }
}

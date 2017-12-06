//
//  DetailViewController.swift
//  ShoeOsVersion
//
//  Created by Magnolia on 04.12.2017.
//  Copyright © 2017 Mangust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {

    let imageService = DefaultImageService.sharedImageService
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK:- Подключение ViewModel
    var viewModel: APISearchViewModel!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        
        collectionView!.register(UINib(nibName: "ImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")
        
        configureCollectionCellSize()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Скроллим к нужной картинке
        collectionView?.scrollToItem(at: IndexPath(row: viewModel.photoWeScrollTo, section: 0), at: UICollectionViewScrollPosition.right, animated: true)
        
        
        print("selfTitle", self.title ?? "", "photoWeScrollTo: ", viewModel.photoWeScrollTo)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: NSDate? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    
    /// Высота и ширина ячейки пусть будет под размер родительского view
    func configureCollectionCellSize() {
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize.init(width: (self.view.frame.size.width), height: UIScreen.main.bounds.height)
    }
    
    func isViewModelEmpty() -> Bool {
        
        guard let _ = viewModel else {
            return true
        }
        
        return false
        
    }

}

extension DetailViewController:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isViewModelEmpty() {
            return 1
        }
        
        return viewModel.numberOfVersions
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCollectionCell else { fatalError("Unexpected Collection View Cell") }
        let reachabilityService = Dependencies.sharedDependencies.reachabilityService
        
        if isViewModelEmpty() {
            return cell
        }
        
        let vm = viewModel.viewModelForVersion(at: indexPath.row)!
        
        let url = URL(string: vm.imageUrl!)
        
        cell.downloadableImage = self.imageService.imageFromURL(url!, reachabilityService: reachabilityService)
        
        cell.titleLabel.text = vm.title
        
//        updateTitle(withText: vm.title!)
        print("curIndex: ", indexPath.row, "vm.imageUrl", vm.imageUrl!, "\n title: ", vm.title ?? "", "\n ", isViewLoaded)
        
        return cell
        
    }
    
    func updateTitle(withText: String) {
        DispatchQueue.main.async {
            self.title = withText
        }
    }
    
}

extension DetailViewController: UICollectionViewDelegate {
    
//    func collectionView(_ collectionView: UICollectionView,
//                        willDisplay cell: UICollectionViewCell,
//                        forItemAt indexPath: IndexPath) {
//        
//        updateTitle(withText: "")
//        
//    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        didEndDisplaying cell: UICollectionViewCell,
//                        forItemAt indexPath: IndexPath) {
//        
//    }
    
    
    
}

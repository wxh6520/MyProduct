//
//  WaterfallCollectionController.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/2/6.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import UIKit
import Photos

class WaterfallCollectionController: BaseCollectionViewController {

    var assets = [PHAsset]()
    let mosaicLayout = MosaicLayout()

    init() {
        super.init(collectionViewLayout: mosaicLayout)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "瀑布流"
        
        // Setup the mosaic collection view.
        collectionView.backgroundColor = UIColor.appBackgroundColor
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.alwaysBounceVertical = true
        collectionView.indicatorStyle = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MosaicCell.self, forCellWithReuseIdentifier: MosaicCell.identifer)

        // Request authorization to access the Photo Library.
        PHPhotoLibrary.requestAuthorization { (status: PHAuthorizationStatus) in
            if status == .authorized {
                let results = PHAsset.fetchAssets(with: .image, options: nil)
                results.enumerateObjects({asset, index, stop in
                    self.assets.append(asset)
                })

                DispatchQueue.main.async {
                    // Reload collection view once we've determined our Photos permissions.
                    self.collectionView.reloadData()
                }
            } else {
                self.displayPhotoAccessDeniedAlert()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if collectionView.numberOfItems(inSection: 0) > 0 {
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
    }

    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Always show 50K cells so scrolling performance can be tested.
        return 50_000
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MosaicCell.identifer, for: indexPath) as? MosaicCell
            else { preconditionFailure("Failed to load collection view cell") }

        if !assets.isEmpty {
            let assetIndex = indexPath.item % assets.count
            let asset = assets[assetIndex]
            let assetIdentifier = asset.localIdentifier

            cell.assetIdentifier = assetIdentifier

            PHImageManager.default().requestImage(for: asset, targetSize: cell.frame.size,
                                                  contentMode: .aspectFill, options: nil) { (image, hashable)  in
                                                    if let loadedImage = image, let cellIdentifier = cell.assetIdentifier {

                                                        // Verify that the cell still has the same asset identifier,
                                                        // so the image in a reused cell is not overwritten.
                                                        if cellIdentifier == assetIdentifier {
                                                            cell.imageView.image = loadedImage
                                                        }
                                                    }
            }
        }

        return cell
    }

    private func displayPhotoAccessDeniedAlert() {
        let message = "Access to photos has been previously denied by the user. Please enable photo access for this app in Settings -> Privacy."
        let alertController = UIAlertController(title: "Photo Access",
                                                message: message,
                                                preferredStyle: .alert)
        let openSettingsAction = UIAlertAction(title: "Settings", style: .default) { (_) in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                // Take the user to the Settings app to change permissions.
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openSettingsAction)

        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))

        self.present(alertController, animated: true, completion: nil)
    }
}

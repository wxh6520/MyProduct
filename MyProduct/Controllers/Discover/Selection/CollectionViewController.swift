//
//  CollectionViewController.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/1/17.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import UIKit
import SnapKit

class CollectionViewController: BaseViewController {
    
    var collectionView: UICollectionView!
    
    private let photos = PhotoModel.generatePhotosItems(count: 100)
    private let sectionInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .done, target: self, action: #selector(toggleSelectionMode(_:)))
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = sectionInsets.left
        flowLayout.minimumInteritemSpacing = sectionInsets.left
        flowLayout.sectionInset = sectionInsets
        flowLayout.itemSize = itemSize()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        setEditing(false, animated: false)
        updateUserInterface()
    }

    func updateUserInterface() {
        guard let button = navigationItem.rightBarButtonItem else { return }
        button.title = isEditing ? "Done" : "Select"
    }

    func clearSelectedItems(animated: Bool) {
        collectionView.indexPathsForSelectedItems?.forEach({ (indexPath) in
            collectionView.deselectItem(at: indexPath, animated: animated)
        })
        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
    }
    
    func itemSize() -> CGSize {
        let itemsPerRow: CGFloat = 3
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        guard isEditing != editing else {
            // Nothing to do. The caller didn't change the editing flag value.
            return
        }
        
        super.setEditing(editing, animated: animated)
        collectionView.allowsMultipleSelection = editing

        clearSelectedItems(animated: true)
        updateUserInterface()
    }

    @objc
    func toggleSelectionMode(_ sender: Any) {
        // Toggle selection state.
        setEditing(!isEditing, animated: true)
    }

}

extension CollectionViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath)

        if let photoCell = cell as? CollectionViewCell {
            photoCell.configureCell(with: photos[indexPath.item], showSelectionIcons: collectionView.allowsMultipleSelection)
        }
    
        return cell
    }
    
}

extension CollectionViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Automatically deselect items when the app isn't in edit mode.
        if isEditing == false {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
    }
    
    // MARK: - Multiple selection methods.

    /// - Tag: collection-view-multi-select
    func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        // Returning `true` automatically sets `collectionView.allowsMultipleSelection`
        // to `true`. The app sets it to `false` after the user taps the Done button.
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        // Replace the Select button with Done, and put the
        // collection view into editing mode.
        setEditing(true, animated: true)
    }
    
    func collectionViewDidEndMultipleSelectionInteraction(_ collectionView: UICollectionView) {
        print("\(#function)")
    }
    
}

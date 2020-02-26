//
//  CustomDataSource.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/2/5.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import Foundation
import UIKit

/// - Tag: CustomDataSource
class CustomDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    // MARK: Properties
    
    struct Model {
        var id = UUID()
        
        // Add additional properties for your own model here.
    }

    /// Example data identifiers.
    private let models = (1...1000).map { _ in
        return Model()
    }

    /// An `AsyncFetcher` that is used to asynchronously fetch `DisplayData` objects.
    private let asyncFetcher = CollectionAsyncFetcher()

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }

    /// - Tag: CellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewPrefetchCell.reuseIdentifier, for: indexPath) as? CollectionViewPrefetchCell else {
            fatalError("Expected `\(CollectionViewPrefetchCell.self)` type for reuseIdentifier \(CollectionViewPrefetchCell.reuseIdentifier). Check the configuration in Main.storyboard.")
        }
        
        let model = models[indexPath.row]
        let id = model.id
        cell.representedId = id
        
        // Check if the `asyncFetcher` has already fetched data for the specified identifier.
        if let fetchedData = asyncFetcher.fetchedData(for: id) {
            // The data has already been fetched and cached; use it to configure the cell.
            cell.configure(with: fetchedData)
        } else {
            // There is no data available; clear the cell until we've fetched data.
            cell.configure(with: nil)

            // Ask the `asyncFetcher` to fetch data for the specified identifier.
            asyncFetcher.fetchAsync(id) { fetchedData in
                DispatchQueue.main.async {
                    /*
                     The `asyncFetcher` has fetched data for the identifier. Before
                     updating the cell, check if it has been recycled by the
                     collection view to represent other data.
                     */
                    guard cell.representedId == id else { return }
                    
                    // Configure the cell with the fetched image.
                    cell.configure(with: fetchedData)
                }
            }
        }

        return cell
    }

    // MARK: UICollectionViewDataSourcePrefetching

    /// - Tag: Prefetching
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // Begin asynchronously fetching data for the requested index paths.
        for indexPath in indexPaths {
            let model = models[indexPath.row]
            asyncFetcher.fetchAsync(model.id)
        }
    }

    /// - Tag: CancelPrefetching
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        // Cancel any in-flight requests for data for the specified index paths.
        for indexPath in indexPaths {
            let model = models[indexPath.row]
            asyncFetcher.cancelFetch(model.id)
        }
    }
}

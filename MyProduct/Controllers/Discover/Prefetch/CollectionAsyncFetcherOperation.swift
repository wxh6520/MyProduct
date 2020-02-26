//
//  CollectionAsyncFetcherOperation.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/2/5.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import Foundation

class CollectionAsyncFetcherOperation: Operation {
    // MARK: Properties

    /// The `UUID` that the operation is fetching data for.
    let identifier: UUID

    /// The `DisplayData` that has been fetched by this operation.
    private(set) var fetchedData: DisplayData?

    // MARK: Initialization

    init(identifier: UUID) {
        self.identifier = identifier
    }

    // MARK: Operation overrides

    override func main() {
        // Wait for a second to mimic a slow operation.
        Thread.sleep(until: Date().addingTimeInterval(1))
        guard !isCancelled else { return }
        
        fetchedData = DisplayData()
    }
}

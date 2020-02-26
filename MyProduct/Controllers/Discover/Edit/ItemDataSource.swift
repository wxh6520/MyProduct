//
//  DataSource.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/1/15.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class ItemDataSource: NSObject, UITableViewDataSource {
    
    static let cellIdentifier = "ItemMasterViewController"
    
    var dataArray = [Item]()
    var storeURL: URL!
    
    private static var sharedDataSource: ItemDataSource = {
        let sharedDataSource = ItemDataSource()
        return sharedDataSource
    }()
    
    class func shared() -> ItemDataSource {
        return sharedDataSource
    }
    
    override private init() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let dataFileURL = documentsDirectory[0]
        storeURL = dataFileURL.appendingPathComponent("SavedData")
        if FileManager.default.fileExists(atPath: storeURL.path) {
            do {
                let fileData = try Data(contentsOf: storeURL)
                let decoder = PropertyListDecoder()
                if let decodedData = try? decoder.decode(Array<Item>.self, from: fileData) {
                    dataArray = decodedData
                }
            } catch {
                Swift.debugPrint("Couldn't read data file.")
            }
        }
    }
    
    func save() {
        do {
            let encoder = PropertyListEncoder()
            if let encoded = try? encoder.encode(dataArray) {
                try encoded.write(to: storeURL)
            }
        } catch {
            Swift.debugPrint("Couldn't write data file.")
        }
            
    }
    
    // MARK: Accessors
    
    func count() -> Int {
        return dataArray.count
    }
    
    func itemFromIdentifier(_ identifier: String) -> Item {
        let filtered = dataArray.filter { $0.identifier == identifier }
        return filtered[0]
    }
    
    func indexPathForItem(_ item: Item) -> IndexPath? {
        if let index = self.dataArray.firstIndex(of: item) {
            return IndexPath(row: index, section: 0)
        } else {
            return nil
        }
    }

    // MARK: Modifiers
    
    func addItem(_ item: Item) {
        dataArray.append(item)
    }
    
    func itemAtIndex(_ index: Int) -> Item {
        return dataArray[index]
    }
    
    func removeItemAtIndex(_ index: Int) {
        dataArray.remove(at: index)
    }
    
    func insertItem(_ item: Item, index: Int) {
        dataArray.insert(item, at: index)
    }
    
    func replaceItem(_ item: Item, index: Int) {
        dataArray[index] = item
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: ItemDataSource.cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: ItemDataSource.cellIdentifier)
        }
        cell.textLabel!.text = dataArray[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // Allow for editing this row object.
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true // Allow for moving this row object.
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = ItemDataSource.shared().itemAtIndex(sourceIndexPath.row)
        ItemDataSource.shared().removeItemAtIndex(sourceIndexPath.row)
        ItemDataSource.shared().insertItem(itemToMove, index: destinationIndexPath.row)
    }
}

extension ItemDataSource {
    @available(iOS 11.0, *)
    func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
        let placeName = dataArray[indexPath.row]
        
        let encoder = PropertyListEncoder()
        var data: Data?
        
        if let encoded = try? encoder.encode(placeName) {
            data = encoded
        }
        let itemProvider = NSItemProvider()
        
        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
            completion(data, nil)
            return nil
        }

        return [
            UIDragItem(itemProvider: itemProvider)
        ]
    }
    
    @available(iOS 11.0, *)
    func canHandle(_ session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: Item.self)
    }
}

extension ItemDataSource: UITableViewDragDelegate {
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return dragItems(for: indexPath)
    }
}

extension ItemDataSource: UITableViewDropDelegate {
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return canHandle(session)
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if tableView.hasActiveDrag {
            if session.items.count > 1 {
                return UITableViewDropProposal(operation: .cancel)
            } else {
                return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
        } else {
            return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            // Get last index path of table view.
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        coordinator.session.loadObjects(ofClass: Item.self) { items in
            // Consume drag items.
            let stringItems = items as! [Item]
            
            var indexPaths = [IndexPath]()
            for (index, item) in stringItems.enumerated() {
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                self.insertItem(item, index: indexPath.row)
                indexPaths.append(indexPath)
            }

            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
}

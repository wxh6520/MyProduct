//
//  ItemViewController.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/1/15.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import UIKit

class ItemMasterViewController: BaseTableViewController {

    static let noteDidChangeNotification = NSNotification.Name("noteDidChangeNotification")
    private var noteDidChangeObserver: NSObjectProtocol!
    
    // MARK: View Controller Lifecycle
    
    init() {
        super.init(style: .plain)
        
        // Add to this class an observer when a note changes.
        noteDidChangeObserver =
            NotificationCenter.default.addObserver(forName: ItemMasterViewController.noteDidChangeNotification,
                                                   object: nil,
                                                   queue: OperationQueue.main) { notification in
                    // A note needs to be saved.
                    if let item = notification.object as? Item {
                        // Find the item to replace with the incoming 'item'.
                        let itemToReplace = ItemDataSource.shared().itemFromIdentifier(item.identifier)
                        if let itemToReplaceIndexPath = ItemDataSource.shared().indexPathForItem(itemToReplace) {
                            ItemDataSource.shared().replaceItem(item, index: itemToReplaceIndexPath.row)
                            ItemDataSource.shared().save()

                            self.tableView.beginUpdates()
                            self.tableView.reloadRows(at: [itemToReplaceIndexPath], with: .automatic)
                            self.tableView.endUpdates()
                        }
                }
            }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(ItemMasterViewController.insertNewObject(_:)))
        self.navigationItem.rightBarButtonItems = [self.editButtonItem, addButton]
        
        tableView.estimatedRowHeight = 50
        tableView.dataSource = ItemDataSource.shared()
        if #available(iOS 11.0, *) {
            tableView.dragInteractionEnabled = true
            tableView.dragDelegate = ItemDataSource.shared()
            tableView.dropDelegate = ItemDataSource.shared()
        }

        if ItemDataSource.shared().count() == 0 {
            // Save 10 default note items.
            for index in 1...9 {
                ItemDataSource.shared().addItem(Item(title: "Item \(index)", notes: "Item \(index) notes", identifier: nil))
            }
            ItemDataSource.shared().save()
        }
    }
    
    @objc
    func insertNewObject(_ sender: AnyObject) {
        let newIndex = ItemDataSource.shared().count()
        let itemToInsert = Item(title: "Item \(newIndex + 1)", notes: "Item \(newIndex + 1) notes", identifier: nil)
        ItemDataSource.shared().insertItem(itemToInsert, index: newIndex)
        
        let indexPath = IndexPath(row: newIndex, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = ItemDataSource.shared().itemAtIndex(indexPath.row)
        let detailCtr = ItemDetailViewController()
        detailCtr.detailItem = item
        detailCtr.delegate = self
        let nav = UINavigationController(rootViewController: detailCtr)
        nav.presentationController?.delegate = detailCtr
        present(nav, animated: true, completion: nil)
    }

}

extension ItemMasterViewController: ItemDetailViewControllerDelegate {
    func itemDetailViewControllerDidCancel(_ detailViewController: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewControllerDidFinish(_ detailViewController: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
}

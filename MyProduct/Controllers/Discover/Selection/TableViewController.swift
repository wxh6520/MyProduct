//
//  TableViewController.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/1/17.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"

class TableViewController: BaseTableViewController {

    let items = FillerModel.generateFillerItems(count: 100)
    
    init() {
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsMultipleSelection = false
        tableView.allowsMultipleSelectionDuringEditing = true
        
        navigationItem.rightBarButtonItem = editButtonItem
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }

        cell.textLabel?.text = items[indexPath.row].title
        cell.detailTextLabel?.text = items[indexPath.row].descriptionText
        cell.detailTextLabel?.numberOfLines = 0

        return cell
    }

    // MARK: - Multiple selection methods.

    /// - Tag: table-view-should-begin-multi-select
    override func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return true
    }

    /// - Tag: table-view-did-begin-multi-select
    override func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        // Replace the Edit button with Done, and put the
        // table view into editing mode.
        self.setEditing(true, animated: true)
    }
    
    /// - Tag: table-view-did-end-multi-select
    override func tableViewDidEndMultipleSelectionInteraction(_ tableView: UITableView) {
        print("\(#function)")
    }

}

//
//  TableSearchController.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/2/9.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import UIKit

class TableSearchController: BaseSearchController {
    
    // MARK: - Types
    
    /// NSPredicate expression keys.
    private enum ExpressionKeys: String {
        case title
        case yearIntroduced
        case introPrice
    }
    
    // MARK: - Properties
    
    /// Data model for the table view.
    var products: [Product] = {
        return [
            Product(title: Product.ProductKind.Ginger, yearIntroduced: 2007, introPrice: 49.98),
            Product(title: Product.ProductKind.Gladiolus, yearIntroduced: 2001, introPrice: 51.99),
            Product(title: Product.ProductKind.Orchid, yearIntroduced: 2007, introPrice: 16.99),
            Product(title: Product.ProductKind.Poinsettia, yearIntroduced: 2010, introPrice: 31.99),
            Product(title: Product.ProductKind.RedRose, yearIntroduced: 2010, introPrice: 24.99),
            Product(title: Product.ProductKind.WhiteRose, yearIntroduced: 2012, introPrice: 24.99),
            Product(title: Product.ProductKind.Tulip, yearIntroduced: 1997, introPrice: 39.99),
            Product(title: Product.ProductKind.Carnation, yearIntroduced: 2006, introPrice: 23.99),
            Product(title: Product.ProductKind.Sunflower, yearIntroduced: 2008, introPrice: 25.00),
            Product(title: Product.ProductKind.Gardenia, yearIntroduced: 2006, introPrice: 25.00)
        ]
    }()
    
    /** The following 2 properties are set in viewDidLoad(),
        They are implicitly unwrapped optionals because they are used in many other places
        throughout this view controller.
    */
    
    /// Search controller to help us with filtering.
    private var searchController: UISearchController!
    
    /// Secondary search results table view.
    private var resultsTableController: ResultsTableController!
    
    // MARK: - View Life Cycle
    
    init() {
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "Table Search"
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .always
        } else {
            // Fallback on earlier versions
        }
        
        resultsTableController = ResultsTableController()

        resultsTableController.tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        
        if #available(iOS 11.0, *) {
            // For iOS 11 and later, place the search bar in the navigation bar.
            navigationItem.searchController = searchController
            
            // Make the search bar always visible.
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // For iOS 10 and earlier, place the search controller's search bar in the table view's header.
            tableView.tableHeaderView = searchController.searchBar
        }
        
        searchController.delegate = self
        if #available(iOS 12.0, *) {
            searchController.obscuresBackgroundDuringPresentation = false // The default is true.
        } else {
            searchController.dimsBackgroundDuringPresentation = false // The default is true.
        }
        searchController.searchBar.delegate = self // Monitor when the search button is tapped.
        
        /** Search presents a view controller by applying normal view controller presentation semantics.
            This means that the presentation moves up the view controller hierarchy until it finds the root
            view controller or one that defines a presentation context.
        */
        
        /** Specify that this view controller determines how the search controller is presented.
            The search controller should be presented modally and match the physical size of this view controller.
        */
        // 暂时没发现这是干嘛的
        definesPresentationContext = true
    }

}

// MARK: - UITableViewDelegate

extension TableSearchController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct: Product
        
        // Check to see which table view cell was selected.
        if tableView === self.tableView {
            selectedProduct = products[indexPath.row]
        } else {
            selectedProduct = resultsTableController.filteredProducts[indexPath.row]
        }
        
        // Set up the detail view controller to show.
        let detailViewController = DetailViewController()
        detailViewController.product = selectedProduct

        navigationController?.pushViewController(detailViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

// MARK: - UITableViewDataSource

extension TableSearchController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: BaseSearchController.tableViewCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: BaseSearchController.tableViewCellIdentifier)
        }
        
        let product = products[indexPath.row]
        configureCell(cell, forProduct: product)
        
        return cell
    }
    
}

// MARK: - UISearchBarDelegate

extension TableSearchController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

// MARK: - UISearchControllerDelegate

// Use these delegate functions for additional control over the search controller.

extension TableSearchController: UISearchControllerDelegate {
    
    func presentSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
}

// MARK: - UISearchResultsUpdating

extension TableSearchController: UISearchResultsUpdating {
    
    private func findMatches(searchString: String) -> NSCompoundPredicate {
        /** Each searchString creates an OR predicate for: name, yearIntroduced, introPrice.
            Example if searchItems contains "Gladiolus 51.99 2001":
                name CONTAINS[c] "gladiolus"
                name CONTAINS[c] "gladiolus", yearIntroduced ==[c] 2001, introPrice ==[c] 51.99
                name CONTAINS[c] "ginger", yearIntroduced ==[c] 2007, introPrice ==[c] 49.98
        */
        var searchItemsPredicate = [NSPredicate]()
        
        /** Below we use NSExpression represent expressions in our predicates.
            NSPredicate is made up of smaller, atomic parts:
            two NSExpressions (a left-hand value and a right-hand value).
        */
        
        // Name field matching.
        let titleExpression = NSExpression(forKeyPath: ExpressionKeys.title.rawValue)
        let searchStringExpression = NSExpression(forConstantValue: searchString)
        
        let titleSearchComparisonPredicate =
            NSComparisonPredicate(leftExpression: titleExpression,
                                  rightExpression: searchStringExpression,
                                  modifier: .direct,
                                  type: .contains,
                                  options: [.caseInsensitive, .diacriticInsensitive])
        
        searchItemsPredicate.append(titleSearchComparisonPredicate)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.formatterBehavior = .default
        
        // The `searchString` may fail to convert to a number.
        if let targetNumber = numberFormatter.number(from: searchString) {
            // Use `targetNumberExpression` in both the following predicates.
            let targetNumberExpression = NSExpression(forConstantValue: targetNumber)
            
            // The `yearIntroduced` field matching.
            let yearIntroducedExpression = NSExpression(forKeyPath: ExpressionKeys.yearIntroduced.rawValue)
            let yearIntroducedPredicate =
                NSComparisonPredicate(leftExpression: yearIntroducedExpression,
                                      rightExpression: targetNumberExpression,
                                      modifier: .direct,
                                      type: .equalTo,
                                      options: [.caseInsensitive, .diacriticInsensitive])
            
            searchItemsPredicate.append(yearIntroducedPredicate)
            
            // The `price` field matching.
            let lhs = NSExpression(forKeyPath: ExpressionKeys.introPrice.rawValue)
            
            let finalPredicate =
                NSComparisonPredicate(leftExpression: lhs,
                                      rightExpression: targetNumberExpression,
                                      modifier: .direct,
                                      type: .equalTo,
                                      options: [.caseInsensitive, .diacriticInsensitive])
            
            searchItemsPredicate.append(finalPredicate)
        }
        
        let orMatchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)
        
        return orMatchPredicate
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // Update the filtered array based on the search text.
        let searchResults = products

        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString =
            searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
        let searchItems = strippedString.components(separatedBy: " ") as [String]

        // Build all the "AND" expressions for each value in searchString.
        let andMatchPredicates: [NSPredicate] = searchItems.map { searchString in
            findMatches(searchString: searchString)
        }

        // Match up the fields of the Product object.
        let finalCompoundPredicate =
            NSCompoundPredicate(andPredicateWithSubpredicates: andMatchPredicates)

        let filteredResults = searchResults.filter { finalCompoundPredicate.evaluate(with: $0) }

        // Apply the filtered results to the search results table.
        if let resultsController = searchController.searchResultsController as? ResultsTableController {
            resultsController.filteredProducts = filteredResults
            resultsController.tableView.reloadData()
        }
    }
    
}


//
//  BookViewModel.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/2/29.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import MFNetworkRequest

class BookViewModel: NSObject,UITableViewDataSource {

    let cellIdentifier = "cell"
    
    var bookAction:Action<(),[BookDataModel],Swift.Error>!
    
    var models = [BookDataModel]()
    
    override init() {
        super.init()
        initialBind()
    }
    
    func initialBind() {
        
        bookAction = Action<(),[BookDataModel],Swift.Error> { (_) -> SignalProducer<[BookDataModel], Swift.Error> in
            SignalProducer<String, Swift.Error>({ (observer, _) in
                
                let bookRequest = MFNetworkRequest()
                bookRequest.sendDataGetRequest(url: "https://api.douban.com/v2/book/search?q=基础&apikey=0df993c66c0c636e29ecbb5344252a4a", successBlock: { (successStr) in
                    observer.send(value: successStr)
                    observer.sendCompleted()
                }, failedBlock: { (failedStr) in
                    
                })
                
            }).map({ (str) -> [BookDataModel] in
                
                let bookObject = try! JSONSerialization.jsonObject(with: str.data(using: .utf8) ?? Data(), options: .mutableContainers)
                let bookDic = bookObject as! Dictionary<String, Any>
                let bookArr = bookDic["books"] as! Array<Dictionary<String,Any>>
                
                var books = [BookDataModel]()
                for book in bookArr {
                    let model = BookDataModel(dic: book)
                    books.append(model)
                }
                
                return books
                
            })

        }
        
    }
    
    //MARK:UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return models.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let book = models[indexPath.row]
        cell?.textLabel?.text = book.title
        cell?.detailTextLabel?.text = book.subtitle
        
        return cell!
        
    }
    
}

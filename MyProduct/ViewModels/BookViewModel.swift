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
        
        // 请求图书列表并解析业务。网络请求，产生信号
        bookAction = Action<(),[BookDataModel],Swift.Error> { (_) -> SignalProducer<[BookDataModel], Swift.Error> in
            SignalProducer<String, Swift.Error>({ (observer, _) in
                
                // MFNetworkRequest是我自己封装的网络请求，成功返回String报文，失败返回错误原因，可忽略。
                let bookRequest = MFNetworkRequest()
                bookRequest.sendDataGetRequest(url: "https://api.douban.com/v2/book/search?q=基础&apikey=0df993c66c0c636e29ecbb5344252a4a", successBlock: { (successStr) in
                    observer.send(value: successStr)
                    observer.sendCompleted()
                }, failedBlock: { (failedStr) in
                    
                })
                
            }).map({ (str) -> [BookDataModel] in
                
                // 将请求成功得到的String报文中的数组解析成BookDataModel数组
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
    // 视图更新
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return models.count
        
    }
    
    // 视图更新
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

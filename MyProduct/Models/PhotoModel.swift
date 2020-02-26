//
//  PhotoModel.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/1/17.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import UIKit

struct PhotoModel {
    
    let name: String
    var image: UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: name)
        } else {
            return UIImage(named: name)
        }
    }
    
    static func generatePhotosItems(count: Int) -> [PhotoModel] {
        var items = [PhotoModel]()
        for _ in 1...count {
            items.append(generatePhotoItem())
        }
        return items
    }
    
    static private var lastName: String = ""
    
    static private var names: [String] = {
        var array = [String]()
        for index in 1...25 {
            array.append("\(index).square")
        }
        return array
    }()
    
    static private func generatePhotoItem() -> PhotoModel {
        // Get a name that is different from the last name.
        var name: String
        repeat {
            name = randomName(from: names)
        } while name == lastName
        lastName = name
        
        return PhotoModel(name: name)
    }
    
    static private func randomName(from array: [String]) -> String {
        return array[randomNumber(upperLimit: array.count)]
    }
    
    static private func randomNumber(upperLimit: Int) -> Int {
        return Int(arc4random() % UInt32(upperLimit))
    }
    
}

//
//  Macro.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/1/15.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import Foundation
import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let NavigationBarHeight: CGFloat = 44


func isIphoneX_XS() -> Bool {
    if SCREEN_WIDTH == 375 && SCREEN_HEIGHT == 812 {
        return true
    } else {
        return false
    }
}

func isIphoneXR_XSMax() -> Bool {
    if SCREEN_WIDTH == 414 && SCREEN_HEIGHT == 896 {
        return true
    } else {
        return false
    }
}

func isFullScreen() -> Bool {
    return isIphoneX_XS() || isIphoneXR_XSMax()
}

func StatusBarHeight() -> CGFloat {
    if isFullScreen() {
        return 44
    } else {
        return 20
    }
}

func StatusBarAndNavigationBarHeight() -> CGFloat {
    if isFullScreen() {
        return 88
    } else {
        return 64
    }
}

func TabbarSafeBottomHeight() -> CGFloat {
    if isFullScreen() {
        return 34
    } else {
        return 0
    }
}

func TabbarHeight() -> CGFloat {
    if isFullScreen() {
        return 49 + 34
    } else {
        return 49
    }
}

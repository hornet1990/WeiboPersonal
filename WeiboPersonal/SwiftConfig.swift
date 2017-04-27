//
//  SwiftConfig.swift
//  ToolsDemo
//
//  Created by Andrew on 2017/1/17.
//
//

import UIKit
import Foundation

let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height

func UIColorFromRGB(_ rgbValue: Int) -> UIColor {
    return UIColor.init(colorLiteralRed: ((Float)((rgbValue & 0xFF0000) >> 16))/255.0, green: ((Float)((rgbValue & 0xFF00) >> 8))/255.0, blue: ((Float)(rgbValue & 0xFF))/255.0, alpha: 1.0)
}
		

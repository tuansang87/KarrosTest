//
//  Utils.swift
//  KarrosTest
//
//  Created by Sang Huynh on 24/3/21.
//

import Foundation
import UIKit



func mPrint(_ parameters: Any?, comment: String = "",  file: NSString = #file, line: Int = #line, functionName: String = #function) {
    #if DEBUG
    
    if let params = parameters {
        if params is String || params is Int  || params is Float || params is CGFloat || params is Double {
            print("[\(file.lastPathComponent):\(line)][\(functionName)] \(comment)", params)
        } else {
            let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("[\(file.lastPathComponent):\(line)][\(functionName)] \(comment)", jsonString)
            }
        }
    } else {
        print(comment, "")
    }
    
    #endif
}


func formatDateStr(_ dateStr : String , _ fromFormat : String, toFormat toFormatStr : String = "MM/dd/yyyy") -> String {
    var mDateStr = dateStr
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = fromFormat
    //    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    if let date = dateFormatter.date(from:dateStr) {
        dateFormatter.dateFormat = toFormatStr
        mDateStr = dateFormatter.string(from: date)
    }
    
    return mDateStr
}

func chatMessage(_ dateStr : String , _ fromFormat : String, toFormat toFormatStr : String = "MM/dd/yyyy") -> String{
    
    
    var mDateStr = dateStr
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = fromFormat
    //    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    if let date = dateFormatter.date(from:dateStr) {
        dateFormatter.dateFormat = toFormatStr
        mDateStr = dateFormatter.string(from: date)
        let now = Date()
        let intervalSec = date.distance(to: now)
        
        let MIN_SEC = 60.0
        let HOUR_SEC = MIN_SEC * 60.0
        let DAY_SEC = 24.0 * HOUR_SEC
        
        let days = intervalSec / DAY_SEC
        let hours = intervalSec / HOUR_SEC
        let mins = intervalSec / MIN_SEC
        if days > 2 {
           return mDateStr
        } else if days > 1 {
            return "Yesterday"
        } else if hours >= 1 {
            return "\(Int(hours)) hours ago"
        } else if mins >= 1 {
            return "\(Int(mins)) minutes ago"
        } else if intervalSec > 1 {
            return "\(Int(mins)) seconds ago"
        } else {
            return "now"
        }
        
    }
    
   
    return ""
}

extension UIView {
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -10, height: 10)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadow_5(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.2
        self.layer.shadowColor = UIColor(hex: "#4A4A4A")!.cgColor
        self.layer.shadowOffset = CGSize(width: -5 , height:5)
    }
    
    func dropShadow_10() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.2
        self.layer.shadowColor = UIColor(hex: "#4A4A4A")!.cgColor
        self.layer.shadowOffset = CGSize(width: -10 , height:10)
    }
    
    
    func dropShadow_20() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 20
        self.layer.shadowOpacity = 0.4
        self.layer.shadowColor = UIColor(hex: "#4A4A4A")!.cgColor
        self.layer.shadowOffset = CGSize(width: -20 , height:20)
    }
    
    
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            var hexColor = String(hex[start...])
            
            
            if hexColor.count == 6 {
                hexColor = "\(hexColor)FF"
            }
            
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255
                
                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        }
        
        return nil
    }
}

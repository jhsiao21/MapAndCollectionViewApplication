//
//  Location.swift
//  MapApplication
//
//  Created by LoganMacMini on 2024/4/7.
//

import Foundation
import UIKit

struct Location: Decodable {
    let locations: [LocationElement]
}

struct LocationElement: Decodable {

    let title: String
    let address: String
    
    var image: UIImage? {
        return UIImage(named: title)
    }
    
    var city: String? {
            // 分割地址字符串，以“市”为界限
            let components = address.components(separatedBy: "市")
            if let firstComponent = components.first, components.count > 1 {
                // 添加“市”回到找到的城市名称部分
                let city = firstComponent + "市"
                return city
            }
            return nil
        }
}

//
//  CommonCollorsStorage.swift
//  DBMS
//
//  Created by Dmitrii Titov on 17.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class CommonCollorsStorage: NSObject {
    
    class func vcBackgroundColor() -> UIColor {
        return UIColor(red: 255 / 255.0, green: 153 / 255.0, blue: 51 / 255.0, alpha: 1)
    }
    
    class func cellBackgroundColor() -> UIColor {
        return UIColor(red: 51 / 255.0, green: 255 / 255.0, blue: 153 / 255.0, alpha: 0.8)
    }
    
    class func cellBackgroundColorHighlighted() -> UIColor {
        return UIColor(red: 51 / 255.0, green: 255 / 255.0, blue: 153 / 255.0, alpha: 0.9)
    }
    
    class func navigationBarBackgroundColor() -> UIColor {
        return UIColor(red: 51 / 255.0, green: 220 / 255.0, blue: 153 / 255.0, alpha: 0.8)
    }
    
    class func tableViewHeaderBackgroundColor() -> UIColor {
        return UIColor(red: 51 / 255.0, green: 220 / 255.0, blue: 153 / 255.0, alpha: 0.8)
    }
    
    class func deleteColor() -> UIColor {
        return UIColor(red: 255 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.9)
    }
}

//
//  UIColorExtension.swift
//  Tasks-CoreData
//
//  Created by Thiago Costa on 5/18/22.
//

import Foundation
import UIKit

extension UIColor {
    func named(_ name: String) -> UIColor? {
        let allColors: [String: UIColor] = ["systemBlue"   : UIColor.systemBlue,
                                            "systemRed"    : UIColor.systemRed,
                                            "systemCyan"   : UIColor.systemCyan,
                                            "systemGray"   : UIColor.systemGray,
                                            "systemMint"   : UIColor.systemMint,
                                            "systemPink"   : UIColor.systemPink,
                                            "systemTeal"   : UIColor.systemTeal,
                                            "systemBrown"  : UIColor.systemBrown,
                                            "systemGreen"  : UIColor.systemGreen,
                                            "systemOrange" : UIColor.systemOrange,
                                            "systemPurple" : UIColor.systemPurple,
                                            "systemIndigo" : UIColor.systemIndigo]
        let cleanedName = name.replacingOccurrences(of: " ", with: "")
        return allColors[cleanedName]
    }
    
    func name() -> String? {
        let allColorNames: [UIColor : String] = [
                  UIColor.systemBlue : "systemBlue"   ,
                   UIColor.systemRed : "systemRed"    ,
                  UIColor.systemCyan : "systemCyan"   ,
                  UIColor.systemGray : "systemGray"   ,
                  UIColor.systemMint : "systemMint"   ,
                  UIColor.systemPink : "systemPink"   ,
                  UIColor.systemTeal : "systemTeal"   ,
                 UIColor.systemBrown : "systemBrown"  ,
                 UIColor.systemGreen : "systemGreen"  ,
                UIColor.systemOrange : "systemOrange" ,
                UIColor.systemPurple : "systemPurple" ,
                UIColor.systemIndigo : "systemIndigo"
            ]
        return allColorNames[self]
    }
}

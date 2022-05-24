//
//  TaskTableViewCell.swift
//  Tasks-CoreData
//
//  Created by Thiago Costa on 5/20/22.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var model: Task? {
        didSet {
            configureUI()
        }
    }
    
    func configureUI() {
        guard let model = model else {
            return
        }

        let largeConfig = UIImage.SymbolConfiguration(pointSize: 35, weight: .bold, scale: .large)
        let largeBoldCircleFill = UIImage(systemName: StringConstants.colorSelectorButtonImageNameNormal , withConfiguration: largeConfig)
        let largeBoldCircle = UIImage(systemName: StringConstants.colorSelectorButtonImageNameSelected, withConfiguration: largeConfig)
        statusButton.setImage(largeBoldCircleFill, for: .normal)
        statusButton.setImage(largeBoldCircle, for: .selected)
            
        let colorName = model.taskList?.color ?? "systemBlue"
        statusButton.tintColor = UIColor().named(colorName)
        
    }
}

//
//  TaksListTableViewCell.swift
//  Tasks-CoreData
//
//  Created by Thiago Costa on 5/15/22.
//

import UIKit

class TaksListTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var totalTasksLabel: UILabel!
    
    private var model: TaskList?
    
    func configure(with taskList: TaskList) {
        titleLabel.text = taskList.name
        totalTasksLabel.text = "\(taskList.tasks?.count ?? 0) "
        
        if let iconName = taskList.icon {
            iconImage.image = UIImage(systemName: iconName)
        } else {
            iconImage.image = UIImage(systemName: "equal.circle.fill")
        }
        
        if let colorName = taskList.color {
            let color = UIColor().named(colorName)
            iconImage.tintColor = color
            titleLabel.textColor = color            
            totalTasksLabel.textColor = color
        } else {
            iconImage.tintColor = .systemBlue
        }
        
        
    }    
}

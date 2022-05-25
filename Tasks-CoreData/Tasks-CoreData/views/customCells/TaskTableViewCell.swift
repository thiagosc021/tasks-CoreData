//
//  TaskTableViewCell.swift
//  Tasks-CoreData
//
//  Created by Thiago Costa on 5/20/22.
//

import UIKit

protocol TaskTableViewCellDelegate: AnyObject {
    func statusButtonTapped(isCompleted: Bool, task: Task)
    func setAlertButtonTapped(isActive: Bool, task: Task)
}

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var setAlertButton: UIButton!
    
    weak var delegate: TaskTableViewCellDelegate?
    var model: Task? {
        didSet {
            configureUI()
        }
    }
 
    @IBAction func statusButtonTapped(_ sender: UIButton) {
        guard let model = model else {
            return
        }        
        sender.isSelected.toggle()
        let isCompleted = sender.isSelected
        delegate?.statusButtonTapped(isCompleted: isCompleted, task: model)
    }
    
    @IBAction func setAlertButtonTapped(_ sender: UIButton) {
        guard let model = model else {
            return
        }
        sender.isSelected.toggle()
        let isActive = sender.isSelected
        delegate?.setAlertButtonTapped(isActive: isActive, task: model)
    }
}

private extension TaskTableViewCell {
    func configureUI() {
        guard let model = model else {
            return
        }
        
        let colorName = model.taskList?.color ?? "systemBlue"
        let color = UIColor().named(colorName)

        configureStatusButton(model, color)
        configureTitleLabel(model, color)
        configureAlertButton(model, color)
    }
    
    func configureTitleLabel(_ model: Task, _ color: UIColor?) {
        titleLabel.text = model.title
        titleLabel.textColor = color
    }
    
    func configureAlertButton(_ model: Task, _ color: UIColor?) {
        let mediumConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular, scale: .default)
        let activeAlert = UIImage(systemName: "bell.fill", withConfiguration: mediumConfig)
        let inactiveAlert = UIImage(systemName: "bell", withConfiguration: mediumConfig)
        let noAlert = UIImage(systemName: "bell.slash", withConfiguration: mediumConfig)
        
        if model.isCompleted() {
            setAlertButton.setImage(noAlert, for: .normal)
            setAlertButton.isEnabled = false
        } else {
            setAlertButton.setImage(activeAlert, for: .selected)
            setAlertButton.setImage(inactiveAlert, for: .normal)
            setAlertButton.isEnabled = true
        }
        setAlertButton.tintColor = color
        setAlertButton.imageView?.contentMode = .scaleToFill
        setAlertButton.isSelected = model.sendNotification
    }
    
    func configureStatusButton(_ model: Task, _ color: UIColor?) {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
        let largeBoldCircleFill = UIImage(systemName: "circle" , withConfiguration: largeConfig)
        let largeBoldCircle = UIImage(systemName: StringConstants.colorSelectorButtonImageNameSelected, withConfiguration: largeConfig)
        statusButton.setImage(largeBoldCircleFill, for: .normal)
        statusButton.setImage(largeBoldCircle, for: .selected)
                
        statusButton.tintColor = color
        statusButton.imageView?.contentMode = .scaleToFill
        statusButton.isSelected = model.isCompleted()
    }
}

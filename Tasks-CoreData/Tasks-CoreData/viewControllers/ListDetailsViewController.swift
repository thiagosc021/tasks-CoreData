//
//  ListDetailsViewController.swift
//  Tasks-CoreData
//
//  Created by Thiago Costa on 5/17/22.
//

import UIKit

class ListDetailsViewController: UIViewController {
    @IBOutlet weak private var doneButton: UIButton!
    @IBOutlet weak private var iconView: UIImageView!
    @IBOutlet weak private var listNameTextView: UITextField!
    @IBOutlet weak private var colorSelectorView: ColorSelectorView!
    @IBOutlet weak private var iconSelectorView: IconSelectorView!
    @IBOutlet weak private var headerContainerView: UIView!
    private var icon: String?
    private var color: UIColor?
    private var modelController = TaskListModelController.shared
    
    var model: TaskList?
    var completion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    @IBAction func doneButtonTapped() {
        let name = listNameTextView.text ?? ""
        
        guard let model = model else {
            modelController.create(name: name, color: self.color?.name(), icon: self.icon)
            dismiss(animated: true)
            completion?()
            return
        }
        
        modelController.update(taskList: model, with: name, color: self.color?.name(), icon: self.icon)
        dismiss(animated: true)
        completion?()
    }
    
    @IBAction func cancelTapped() {
        dismiss(animated: true)
    }
  
    
    @IBAction func textFieldValueDidChange(_ sender: UITextField) {
        doneButton.isEnabled = (sender.text?.count ?? 0) > 0
    }
}

private extension ListDetailsViewController {
    func configureUI() {
        doneButton.isEnabled = false
        headerContainerView.layer.cornerRadius = 12.0
        colorSelectorView.layer.cornerRadius = 12.0
        iconView.clipsToBounds = true
        iconView.layer.cornerRadius = iconView.frame.height / 2
        colorSelectorView.selectColor = { [weak self] color in
            guard let self = self,
                  let color = color else {
                return
            }
            
            self.iconView.tintColor = color
            self.listNameTextView.tintColor = color
            self.listNameTextView.textColor = color
            self.color = color
        }
        iconSelectorView.layer.cornerRadius = 12.0
        iconSelectorView.selectIcon = { [weak self] icon in
            guard let self = self,
                  let icon = icon else {
                return
            }
            
            self.iconView.image = UIImage(systemName: icon)
            self.icon = icon
        }
        
        configureUIForUpdate()
    }
    
    func configureUIForUpdate() {
        guard let model = model else {
            return
        }
        let icon = model.icon ?? "calendar.circle.fill"
        let color = UIColor().named(model.color ?? "systemBlue")
        
        self.iconView.image =  UIImage(systemName: icon)
        self.icon = icon
        self.iconView.tintColor = color
        self.listNameTextView.tintColor = color
        self.listNameTextView.textColor = color
        self.listNameTextView.text = model.name
        self.color = color
        doneButton.isEnabled = true
    }
}

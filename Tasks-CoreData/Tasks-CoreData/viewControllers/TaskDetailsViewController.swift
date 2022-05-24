//
//  TaskDetailsViewController.swift
//  Tasks-CoreData
//
//  Created by Thiago Costa on 5/24/22.
//

import UIKit

class TaskDetailsViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var basicInfoContainerView: UIView!
    @IBOutlet weak var datePickerContainerView: UIView!
    @IBOutlet weak var notificationContainerView: UIView!
    @IBOutlet weak var sendNotificationSwitchButton: UISwitch!
    private var modelController = TaskModelController.shared
    
    var taskList: TaskList?
    var model: Task?
    var completion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    @IBAction func saveButtonTapped() {
        guard let title = titleTextField.text,
              let taskList = taskList else {
            return
        }
                    
        let notes = notesTextField.text
        let dueDate = dueDatePicker.date
        let sendNotification = sendNotificationSwitchButton.isOn
        
        modelController.create(title: title, notes: notes, dueDate: dueDate, sendNotification: sendNotification, taskList: taskList)
        dismiss(animated: true)
        completion?()
    }
    
    @IBAction func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @IBAction func textFieldValueDidChange(_ sender: UITextField) {
        saveButton.isEnabled = (sender.text?.count ?? 0) > 0
    }
}

private extension TaskDetailsViewController {
    func configureUI() {
        basicInfoContainerView.layer.cornerRadius = 12.0
        datePickerContainerView.layer.cornerRadius = 12.0
        notificationContainerView.layer.cornerRadius = 12.0
        
        guard let model = model else {
            return
        }

        titleTextField.text = model.title
        notesTextField.text = model.notes
        dueDatePicker.date = model.dueDate ?? Date()
        sendNotificationSwitchButton.isOn = model.sendNotification
    }
}

//
//  TaskViewController.swift
//  Tasks-CoreData
//
//  Created by Thiago Costa on 5/19/22.
//

import UIKit

class TaskViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var taskListNameLabel: UILabel!
    @IBOutlet weak var tasksTableView: UITableView!
    @IBOutlet weak var showCompletedButton: UIButton!
    
    private var modelController = TaskModelController.shared
    var model: TaskList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        tasksTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "taskCell")
        fetchTasks()
        configureUI()
    }
    
    private func fetchTasks() {
        guard let model = model else {
            return
        }
        modelController.fetch(taskList: model)
    }
   
    @IBAction func showCompletedTapped(_ sender: UIButton) {
        guard let model = model else {
            return
        }
        
        sender.isSelected.toggle()
        if sender.isSelected {
            modelController.showCompletedTasks(for: model)
        } else {
            modelController.hideCompletedTasks()
        }
        tasksTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard  let destination = segue.destination as? TaskDetailsViewController ,
                let model = model else {
            return
        }
        
        destination.taskList = model
        destination.completion = { [weak self] in
            guard let self = self else {
                return
            }
            self.tasksTableView.reloadData()
        }
    }
}

private extension TaskViewController {
    func configureUI() {
        guard let model = model else {
            return
        }
        
        taskListNameLabel.text = model.name
        
        let colorName = model.color ?? "systemBlue"
        let color = UIColor().named(colorName)
        taskListNameLabel.textColor = color
        headerContainerView.layer.cornerRadius = 12.0
        tasksTableView.backgroundColor = .white
        tasksTableView.layer.cornerRadius = 12.0
        configureIconView(with: model, color)
        configureShowCompletedButton(color)
    }
    
    func configureIconView(with model: TaskList,_ color: UIColor?) {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .default)
        let icon = model.icon ?? ""
        let image = UIImage(systemName: icon, withConfiguration: symbolConfig)
        iconImageView.image = image
        iconImageView.tintColor = color
    }
    
    func configureShowCompletedButton(_ color: UIColor?) {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold, scale: .large)
        let showCompleteIcon = UIImage(systemName: "eye.fill" , withConfiguration: symbolConfig)
        let doNotShowCompletedIcon = UIImage(systemName: "eye.slash", withConfiguration: symbolConfig)
        showCompletedButton.setImage(doNotShowCompletedIcon, for: .normal)
        showCompletedButton.setImage(showCompleteIcon, for: .selected)
                
        showCompletedButton.tintColor = color
        showCompletedButton.imageView?.contentMode = .scaleToFill
        showCompletedButton.isSelected = true
    }
}

extension TaskViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return modelController.taskStatus.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelController.tasks[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return modelController.taskStatus[section].description()
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let view = view as? UITableViewHeaderFooterView,
              let colorName = model?.color else {
            return
        }
        
        view.textLabel?.textColor = UIColor().named(colorName)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        
        let task = modelController.tasks[indexPath.section][indexPath.row]
        
        cell.model = task
        cell.delegate = self
        return cell
    }
}

extension TaskViewController: TaskTableViewCellDelegate {
    func setAlertButtonTapped(isActive: Bool, task: Task) {
        modelController.toggleNotificationAlert(isActive, task: task)
        self.fetchTasks()
        self.tasksTableView.reloadData()
    }
    
    func statusButtonTapped(isCompleted: Bool, task: Task) {
        modelController.complete(isCompleted, task: task)
        self.fetchTasks()
        self.tasksTableView.reloadData()
    }
}

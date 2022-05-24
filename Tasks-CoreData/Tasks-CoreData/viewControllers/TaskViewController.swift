//
//  TaskViewController.swift
//  Tasks-CoreData
//
//  Created by Thiago Costa on 5/19/22.
//

import UIKit

class TaskViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var taskListNameLabel: UILabel!
    @IBOutlet weak var tasksTableView: UITableView!
    
    private var modelController = TaskModelController.shared
    var model: TaskList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        
        fetchTasks()
        configureUI()
    }
    
    private func fetchTasks() {
        guard let model = model else {
            return
        }
        modelController.fetch(taskList: model)
    }
    
    private func configureUI() {
        guard let model = model else {
            return
        }
        
        taskListNameLabel.text = model.name
        
        let colorName = model.color ?? "systemBlue"
        taskListNameLabel.textColor = UIColor().named(colorName)
        
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


extension TaskViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return modelController.tasks.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        
        let task = modelController.tasks[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = task.title
        
        return cell
    }
    
    
}

//
//  ViewController.swift
//  Tasks-CoreData
//
//  Created by Thiago Costa on 5/13/22.
//

import UIKit

class TaskListViewController: UIViewController {

    @IBOutlet weak var taskListsTableView: UITableView!
    
    var modelController = TaskListModelController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskListsTableView.delegate = self
        taskListsTableView.dataSource = self
        configureUI()
        modelController.fetch()
    }

    override func viewWillAppear(_ animated: Bool) {
        modelController.fetch()
        taskListsTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? TaskViewController,
              let indexPath = self.taskListsTableView.indexPathForSelectedRow else {
            return
        }
        
        let taskList = modelController.taskLists[indexPath.row]
        
        destinationVC.model = taskList
        
    }

}

private extension TaskListViewController {
    func configureUI() {
        taskListsTableView.backgroundColor = .white
        taskListsTableView.layer.cornerRadius = 10.0
        taskListsTableView.register(UINib(nibName: "TaksListTableViewCell", bundle: nil), forCellReuseIdentifier: "taskListCell")
    }
}

extension TaskListViewController: UITableViewDelegate {
    
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelController.taskLists.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "GoToTasks", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskListCell", for: indexPath) as? TaskListTableViewCell else {
            return UITableViewCell()
        }
        
        let taskList = modelController.taskLists[indexPath.row]
        
        cell.configure(with: taskList)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] _, _, completion in
            guard let self = self else {
                completion(false)
                return
            }
            
            let taskList = self.modelController.taskLists[indexPath.row]
            self.modelController.delete(taskList: taskList)
            self.taskListsTableView.deleteRows(at: [indexPath], with: .automatic)
            
            completion(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash.circle")
        
        let editAction = UIContextualAction(style: .normal, title: "") { [weak self] _, _, completion in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: StringConstants.listInfoViewControllerID) as? ListDetailsViewController else {
                completion(false)
                return
            }
            
            let taskList = self?.modelController.taskLists[indexPath.row]
            vc.model = taskList
            vc.completion = {
                tableView.reloadData()
            }
            self?.navigationController?.present(vc, animated: true)
            completion(true)
        }
        editAction.image = UIImage(systemName: "info.circle")
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
    
}


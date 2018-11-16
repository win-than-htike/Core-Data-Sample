//
//  ViewController.swift
//  CoreData Sample
//
//  Created by Win Than Htike on 11/16/18.
//  Copyright © 2018 PADC. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var taskTableView: UITableView!
    
    var managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var taskList : [Todos] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getTaskList()
    }
    
    func getTaskList() {
        
        do {
            taskList = try managedObjectContext.fetch(Todos.fetchRequest())
            self.taskTableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }

    @IBAction func onClickAdd(_ sender: UIBarButtonItem) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "TaskAddViewController") as! TaskAddViewController
        self.navigationController?.pushViewController(newViewController, animated: true)
        
    }
    
    func deleteTask(taskName : String) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Todos")
        
        fetchRequest.predicate = NSPredicate(format: "name = %@", taskName)
        
        do {
            
            let taskList = try managedObjectContext.fetch(fetchRequest)
            
            if !taskList.isEmpty {
                let task = taskList[0] as! NSManagedObject
                managedObjectContext.delete(task)
            } else {
                print("Result not found.")
            }
            
            do {
                try managedObjectContext.save()
                self.getTaskList()
            } catch {
                print("Failed update.")
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
}

extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        
        cell.accessoryType = .disclosureIndicator
        
        let task = self.taskList[indexPath.row]
        
        cell.taskNameLabel.text = task.name ?? "Unknow Error."
        
        return cell
        
    }
    
    
}

extension ViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "TaskAddViewController") as! TaskAddViewController
        newViewController.task = self.taskList[indexPath.row]
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.deleteTask(taskName: self.taskList[indexPath.row].name ?? "")
        }
        
    }
    
}


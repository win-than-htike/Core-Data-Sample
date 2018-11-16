//
//  TaskAddViewController.swift
//  CoreData Sample
//
//  Created by Win Than Htike on 11/16/18.
//  Copyright © 2018 PADC. All rights reserved.
//

import UIKit
import CoreData

class TaskAddViewController: UIViewController {

    @IBOutlet weak var tfAddText: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    private var isUpdate = false
    private var taskName = ""
    
    var task : Todos?

    var managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let task = task {
            tfAddText.text = task.name
            self.taskName = task.name!
            isUpdate = true
        } else {
            tfAddText.text = ""
            isUpdate = false
        }
        
    }

    @IBAction func onClickAdd(_ sender: UIButton) {
        
        if isUpdate {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Todos")
            
            fetchRequest.predicate = NSPredicate(format: "name = %@", taskName)
            
            do {
                
                let taskList = try managedObjectContext.fetch(fetchRequest)
                
                if !taskList.isEmpty {
                    let task = taskList[0] as! NSManagedObject
                    task.setValue(tfAddText.text!, forKey: "name")
                } else {
                    print("Result not found.")
                }
                
                do {
                    try managedObjectContext.save()
                    self.navigationController?.popViewController(animated: true)
                } catch {
                    print("Failed update.")
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
            
        } else {
            
            let entity = NSEntityDescription.entity(forEntityName: "Todos", in: managedObjectContext)
            
            let newTask = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
            
            newTask.setValue(tfAddText.text!, forKey: "name")
            
            do {
                try managedObjectContext.save()
                self.navigationController?.popViewController(animated: true)
            } catch {
                print("Failed saving")
            }
            
        }
        
    }
    
}

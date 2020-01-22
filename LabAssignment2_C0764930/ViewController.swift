//
//  ViewController.swift
//  LabAssignment2_C0764930
//
//  Created by MacStudent on 2020-01-21.
//  Copyright © 2020 MacStudent. All rights reserved.
//


import UIKit
import CoreData

class ViewController: UIViewController {
    
    var tasks: [Task]?
    
    weak var taskTable: TaskTableViewController?
    


    @IBOutlet var txtDetails: [UITextField]!
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCoreData()
        NotificationCenter.default.addObserver(self, selector: #selector(saveCoreData), name: UIApplication.willResignActiveNotification, object: nil)
    
    }
    
    func getFilePath() -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if documentPath.count > 0 {
            let documentDirectory = documentPath[0]
            let filePath = documentDirectory.appending("/task.txt")
            return filePath
        }
        return ""
    }

    
    @IBAction func saveButton(_ sender: Any) {
    
    let title = txtDetails[0].text ?? ""
        let days = Int(txtDetails[1].text ?? "0") ?? 0
                   
                
        let task = Task(title: title, days: days)
        tasks?.append(task)
         saveCoreData()
                   for textField in txtDetails {
                       textField.text = ""
                       textField.resignFirstResponder()
                   }
       
    }
    
    @objc func saveCoreData(){
        
       // call clear core data
        clearCoreData()
        
        //create an instance of app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // context
        let ManagedContext = appDelegate.persistentContainer.viewContext
        
        for task in tasks!{
            let taskEntity = NSEntityDescription.insertNewObject(forEntityName: "TaskEntity", into: ManagedContext)
            taskEntity.setValue(task.title, forKey: "title")
            taskEntity.setValue(task.days, forKey: "daysRequired")
            
            do{
                try ManagedContext.save()
            }catch{
                print(error)
            }
            
            
            print("days: \(task.days)")
        }
        
        loadCoreData()
    }
   
    
    func loadCoreData(){
        tasks = [Task]()
        //create an instance of app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // context
        let ManagedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        
        do{
            let results = try ManagedContext.fetch(fetchRequest)
            if results is [NSManagedObject]{
                for result in results as! [NSManagedObject]{
                    let title = result.value(forKey:"title") as! String
                    
                    let days = result.value(forKey: "daysRequired") as! Int
                    
                    
                    tasks?.append(Task(title: title, days: days))
                    
                }
            }
        } catch{
            print(error)
        }
        print(tasks!.count )
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//
//        tasks?.updateText(taskArray: tasks!)
//        //taskTable?.updateTask(task: task1!)
//
//    }
    
    func clearCoreData(){
        
        
        //create an instance of app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // context
        let ManagedContext = appDelegate.persistentContainer.viewContext
        
        //create fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        
        fetchRequest.returnsObjectsAsFaults = false
        do{
            
            let results = try ManagedContext.fetch(fetchRequest)
            for managedObjects in results{
                if let managedObjectsData = managedObjects as? NSManagedObject{
                    
                    ManagedContext.delete(managedObjectsData)
                }
            }
        }
        catch{
            print(error)
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


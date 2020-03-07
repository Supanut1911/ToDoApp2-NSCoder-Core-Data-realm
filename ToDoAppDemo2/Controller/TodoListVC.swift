//
//  ViewController.swift
//  ToDoAppDemo2
//
//  Created by Supanut Laddayam on 7/3/2563 BE.
//  Copyright © 2563 Supanut Laddayam. All rights reserved.
//

import UIKit
import CoreData

class TodoListVC: UIViewController {

    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var todoListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loaditem()
    }
    
    func saveItem() {
         
         do {
            try context.save()
         } catch{
             print("Error saving context : \(error)")
         }

         self.todoListTableView.reloadData()
        
    }
    
    func loaditem() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }

    @IBAction func addDidTap(_ sender: Any) {
        
        var textFiled = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in

            var newitem = Item(context: self.context)
            newitem.title = textFiled.text!
            newitem.done = false
            self.itemArray.append(newitem)
            
            self.saveItem()
        }
        
        let Cancel = UIAlertAction(title: "Cancel", style: .default) { (cancel) in
            
        }
        
        alert.addTextField { (tf) in
            tf.placeholder = "Create new Item"
            textFiled = tf
        }
        
        alert.addAction(action)
        alert.addAction(Cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
}
extension TodoListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = todoListTableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
         
        return cell
    }
    
    
}

extension TodoListVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
         context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
       
        
        saveItem()
        
        todoListTableView.reloadData()
        
        self.todoListTableView.deselectRow(at: indexPath, animated: true)
    }
}

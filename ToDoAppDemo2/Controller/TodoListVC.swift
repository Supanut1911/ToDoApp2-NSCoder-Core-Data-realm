//
//  ViewController.swift
//  ToDoAppDemo2
//
//  Created by Supanut Laddayam on 7/3/2563 BE.
//  Copyright © 2563 Supanut Laddayam. All rights reserved.
//

import UIKit

class TodoListVC: UIViewController {

    var itemArray = [Item]()

    let datafilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    @IBOutlet weak var todoListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(datafilepath)
        
        loaditem()
    }
    
    func saveItem() {
        let encoder = PropertyListEncoder()
         
         do {
              let data = try encoder.encode(self.itemArray)
             try data.write(to: self.datafilepath!)
         } catch{
             print(error.localizedDescription)
         }
        
         
         
         self.todoListTableView.reloadData()
        
    }
    
    func loaditem() {
        if let data = try? Data(contentsOf: datafilepath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    @IBAction func addDidTap(_ sender: Any) {
        
        var textFiled = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in

            var newitem = Item()
            newitem.title = textFiled.text!
            
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
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItem()
        
        todoListTableView.reloadData()
        
        self.todoListTableView.deselectRow(at: indexPath, animated: true)
    }
}

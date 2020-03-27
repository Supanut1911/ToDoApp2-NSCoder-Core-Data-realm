//
//  ViewController.swift
//  ToDoAppDemo2
//
//  Created by Supanut Laddayam on 7/3/2563 BE.
//  Copyright © 2563 Supanut Laddayam. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class TodoListVC: UIViewController, UIPickerViewDelegate, UIImagePickerControllerDelegate{

    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectCategory: Category? {
        didSet{
//            loaditem()
        }
    }
    
    
    
    @IBOutlet weak var todoListTableView: UITableView!
    
    @IBOutlet weak var searchBar: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loaditem()
    }
    
    
    func loaditem() {

        todoItems = selectCategory?.items.sorted(byKeyPath: "title", ascending: true)

        todoListTableView.reloadData()
    }
    
    @IBAction func addDidTap(_ sender: Any) {
        
        var textFiled = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in

            if let currentCategory = self.selectCategory {
                do {
                    try self.realm.write{
                      let  newitem = Item()
                      newitem.title = textFiled.text!
                      currentCategory.items.append(newitem)
                    }
                } catch {
                    print("error add, \(error)")
                }
            }
            
            self .todoListTableView.reloadData()
        }
        
        
        
        alert.addTextField { (tf) in
            tf.placeholder = "Create new Item"
            textFiled = tf
        }
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
    }
    
}
extension TodoListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = todoListTableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done == true ? .checkmark : .none
             
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        
        return cell
    }
    
    
}

extension TodoListVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
            try realm.write {
//                item.done = !item.done
                realm.delete(item)
            }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        todoListTableView.reloadData()
        
        self.todoListTableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK:- search bar methods
//extension TodoListVC: UISearchBarDelegate{
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        //query data
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loaditem(with: request, predicate: predicate)
//
//
//        todoListTableView.reloadData()
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text!.isEmpty || searchBar.text!.count == 0{
//            loaditem()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//        }
//    }
//
//}

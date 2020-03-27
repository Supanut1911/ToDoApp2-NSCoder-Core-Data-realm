//
//  CategoryVC.swift
//  ToDoAppDemo2
//
//  Created by Supanut Laddayam on 8/3/2563 BE.
//  Copyright © 2563 Supanut Laddayam. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryVC: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    let realm = try! Realm()

    var categories: Results<Category>?
        
    
    
    @IBOutlet weak var categoryTable: UITableView!
    
    
    override func viewDidLoad() {
          super.viewDidLoad()
        loadCategories()
        
    }
    
    //MARK:- Data Manipulation Methods
    func save(category: Category) {
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("Error saving categories \(error )")
        }
        
        categoryTable.reloadData()
    }
    
    func loadCategories() {
        
        //one line to call data
        categories = realm.objects(Category.self)
        
        categoryTable.reloadData()
    }
    
    
    @IBAction func addCategoryDidtap(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!

            self.save(category: newCategory)
        }
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add new Category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- TableView Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoItems", sender: self)
    }
    
    //MARK:- TableView DataSource Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListVC
        
        if let indexPath = categoryTable.indexPathForSelectedRow {
            destinationVC.selectCategory = categories?[indexPath.row]
        }
    }
    
  
    
    
    

}








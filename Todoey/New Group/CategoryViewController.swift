//
//  CategoryViewController.swift
//  Todoey
//
//  Created by ishan on 2/8/19.
//  Copyright © 2019 ishan. All rights reserved.
//

import UIKit
import CoreData

//Write the protocol declaration here:
protocol CategoryDelegate {
    func userSelectedCategory(name:String)
}

class CategoryViewController: UITableViewController {

    var todoCategory:[Category]  = [Category] ()
    var delegate:CategoryDelegate?
    var selectedCategory: Category?
    
    //context for database
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadData()
    }
    
    
    //MARK: - no of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoCategory.count
    }
    
    //MARK: - Table cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier:"categoryCell", for: indexPath)
        cell.textLabel?.text = todoCategory[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //delegate?.userSelectedCategory(name: todoCategory[indexPath.row].title!)
        selectedCategory = todoCategory[indexPath.row]
        performSegue(withIdentifier: "gotoItem", sender: self)
        
    }
    
    
    
    @IBAction func onAddCategory(_ sender: UIBarButtonItem) {
        var alertTextView:UITextField?
        
        let alert = UIAlertController(title: "Add Category", message: "Add new Category", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let category = Category(context: self.context);
            category.title = (alertTextView?.text)!
           
            
            self.todoCategory.append(category)
            //self.userPersistence.set(self.todoItemArray, forKey: "TODO_DATA")
            self.saveCoreData()
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertText) in
            alertText.placeholder = "Enter text"
            alertTextView = alertText
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    func saveCoreData() {
        do{
            try context.save()
            self.tableView.reloadData()
        }catch {
            print("\(error)")
        }
    }
    
    func loadData(with request:NSFetchRequest<Category> = Category.fetchRequest() )  {
        
        do{
            todoCategory = try context.fetch(request)
            tableView.reloadData()
        }
        catch {
            print("\(error)")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoItem"{
            print("source cat \(selectedCategory?.title)")
            var todoCont = segue.destination as! TodoListViewController
            todoCont.category = self.selectedCategory
        }
    }
    
}

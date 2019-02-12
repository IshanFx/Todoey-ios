//
//  ViewController.swift
//  Todoey
//
//  Created by ishan on 2/2/19.
//  Copyright © 2019 ishan. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController,CategoryDelegate {

    
    var todoItemArray:[Item]  = [Item] ()
    var newItem = ""
    let userPersistence = UserDefaults.standard
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var category:Category? {
        didSet{
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //todoItemArray = Item().getItemList()
        // Do any additional setup after loading the view, typically from a nib.
//        if let items = NSKeyedUnarchiver.unarchiveObject(with: self.userPersistence.data(forKey: "TODO_DATA")!) as! [Item]? {
//            todoItemArray = items
//        }
        print(category?.title)
        //loadData()
       
         //let context = (UI)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: .default, reuseIdentifier:"toduCell" )
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        let item = todoItemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = todoItemArray[indexPath.row].checked ? .checkmark : .none
        
        return cell;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //todoItemArray[indexPath.row].checked = !todoItemArray[indexPath.row].checked
        
        context.delete(todoItemArray[indexPath.row]);
        todoItemArray.remove(at: indexPath.row)
        saveCoreData()
        tableView.reloadData()
    }
    
    //MARK - Add new item
    @IBAction func onAddItem(_ sender: UIBarButtonItem) {
        
        var alertTextView:UITextField?
        
        let alert = UIAlertController(title: "Add Item", message: "Add new todoey Item", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let item = Item(context: self.context);
            item.title = (alertTextView?.text)!
            item.checked = false
            item.parentCategory = self.category
            
            self.todoItemArray.append(item)
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
    
    func saveEncodedData()  {
       
//        do{
//            let encoder = PropertyListEncoder()
//            let data = try encoder.encode(self.todoItemArray)
//            try data.write(to: filePath!)
//        }catch {
//
//        }
    }
    
    func saveCoreData(){
        do{
            try context.save()
        }
        catch {
            
        }
        self.tableView.reloadData()
    }
    
    func loadData(with request:NSFetchRequest<Item> = Item.fetchRequest(),predicate:NSPredicate? = nil )  {
       
        do{
            let catPredicate = NSPredicate(format: "parentCategory.title CONTAINS[cd] %@", (category?.title!)!)
            
            if let additionalPredicate = predicate { //optional binding
                let compoundPredicate  = NSCompoundPredicate(andPredicateWithSubpredicates: [catPredicate,additionalPredicate])
                request.predicate = compoundPredicate
            } else {
                request.predicate = catPredicate
            }
           
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            todoItemArray = try context.fetch(request)
            tableView.reloadData()
        }
        catch {
            print("\(error)")
        }
//        if let data = try? Data(contentsOf: filePath!){
//             let decode = PropertyListDecoder()
//        do{
//          self.todoItemArray = try decode.decode([Item].self, from: data)
//        }catch {
//
//        }
//        }
    }
    

}


extension TodoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(searchBar.text != nil && !(searchBar.text?.isEmpty)!){
            let request:NSFetchRequest<Item> = Item.fetchRequest()
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            loadData(with: request,predicate: predicate)
        } else {
            loadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0{
             loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
    func userSelectedCategory(name: String) {
        print(name)
    }
    
}

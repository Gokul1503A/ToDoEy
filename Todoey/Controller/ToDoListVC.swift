//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

import RealmSwift

import ChameleonFramework

class ToDoListVC: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var toDoItems: Results<Item>?
    
    var selectedCatagory: Catagory? {
        didSet{
            loadData()
        }
    }
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCatagory!.name
        if let ColorHex = selectedCatagory?.Colour {
            navigationController?.navigationBar.barTintColor = UIColor(hexString: ColorHex)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = toDoItems?[indexPath.row].title ?? "No things to show"
        
        
        if let color = UIColor(hexString: selectedCatagory!.Colour)?.darken(byPercentage:
        
                                                                                CGFloat(indexPath.row)/CGFloat(toDoItems!.count))
        {
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        
        
        if toDoItems?[indexPath.row].done == false{
            cell.accessoryType = .none
        }
        else{
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = toDoItems?[indexPath.row] {
            do{
                try realm.write{
                    item.done = !item.done
                    
                }
            }
            catch{
                print(error)
            }
        }
        tableView.reloadData()
        

        
    }
    
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var text = UITextField()
        
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default){
            (action) in
            
            if let currentCatagory = self.selectedCatagory{
                
                
                
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = text.text!
                        currentCatagory.items.append(newItem)
                    }
                }catch{
                    print(error)
                }
            }
            
            
            self.tableView.reloadData()
        }
        alert.addTextField(){
            (alertTextField) in
           
            text = alertTextField
           
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    

    func loadData(){
        
        
        toDoItems = selectedCatagory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let safeObject = toDoItems?[indexPath.row]{
            do{
                try realm.write{
                    realm.delete(safeObject)
                }
            }catch{
                print(error)
            }
        }
    }
//
}
//
// MARK: - extension for searchbar

extension ToDoListVC: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadData()
            DispatchQueue.main.async{
                searchBar.resignFirstResponder()
            }
        }
        else{
            searchBarSearchButtonClicked(searchBar)
        }
    }
    
}

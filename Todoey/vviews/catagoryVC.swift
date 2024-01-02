//
//  catagoryVC.swift
//  Todoey
//
//  Created by KOPPOLA GOKUL SAI on 28/12/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class catagoryVC: SwipeTableViewController {
    
    let realm = try! Realm()
    var catagories: Results<Catagory>?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "1D9BF6")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.backgroundColor = UIColor(hexString: catagories?[indexPath.row].Colour ?? "000000")
        
        cell.textLabel?.text = catagories?[indexPath.row].name ?? "Add new Catagory"
        
        cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: catagories?[indexPath.row].Colour ?? "000000") ?? .black, returnFlat: true)
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desinationVC = segue.destination as! ToDoListVC
        
        if let indexPath = tableView.indexPathForSelectedRow{
            desinationVC.selectedCatagory = catagories?[indexPath.row]
        }
    }

    @IBAction func addCatagory(_ sender: UIBarButtonItem) {
        
        var text = UITextField()
        
        
        let alert = UIAlertController(title: "Add New Catagory", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add catagory", style: .default){
            (action) in
            
            let newCatagory = Catagory()
            newCatagory.name = text.text!
            newCatagory.Colour = UIColor.randomFlat().hexValue()
            self.saveData(catagory: newCatagory)

            
        }
        alert.addTextField(){
            (alertTextField) in
           
            text = alertTextField
           
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func saveData(catagory: Catagory){
        
        do {
            try realm.write{
                realm.add(catagory)
            }
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadData(){
        catagories = realm.objects(Catagory.self)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let safeCatagory = self.catagories?[indexPath.row]{
                        do{
                            try self.realm.write{
                                self.realm.delete(safeCatagory)
                            }
                        }catch {
                            print(error)
                        }
                    }
    }
}



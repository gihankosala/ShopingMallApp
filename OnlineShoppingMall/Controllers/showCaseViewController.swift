//
//  showCaseViewController.swift
//  OnlineShoppingMall
//
//  Created by Admin on 3/25/21.
//  Copyright © 2021 Admin. All rights reserved.
//

import UIKit
import CoreData

class showCaseViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate {
    
    
    
    var resultfromDb:Any?
    var selectedId = 0
    @IBOutlet weak var showCaseTableView: UITableView!
    lazy var searchBar:UISearchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        addShopsDataToDb()
        getShopsDataFromDb()
        
        //adding search bar
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        showCaseTableView.tableHeaderView = searchBar
        
    }
    
    func setUpNavigationBar(){
        //navigation bar
        //let backButton = UIBarButtonItem(image: UIImage(named: "back icn"), style: .plain, target: self, action: #selector(backButtonAction(_:)))
        //self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.green
        self.navigationItem.title = "Shop ShowCase"
        
    }
    
    //adding default shops to db
    func addShopsDataToDb(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Shops")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try context.execute(request)
        } catch {
            print("Failed deleting")
        }
        
        
        let entity = NSEntityDescription.entity(forEntityName: "Shops", in: context)
        
        let shop1 = NSManagedObject(entity: entity!, insertInto: context)
        
        shop1.setValue(1, forKey: "id")
        shop1.setValue("Abans", forKey: "name")
        shop1.setValue("Colombo 03", forKey: "location")
        shop1.setValue("abans-img", forKey: "image")
        shop1.setValue(6.9271, forKey: "longtide")
        shop1.setValue(79.8612, forKey: "latitude")
        
        let shop2 = NSManagedObject(entity: entity!, insertInto: context)
        
        shop2.setValue(2, forKey: "id")
        shop2.setValue("Softlogic", forKey: "name")
        shop2.setValue("Colombo 04", forKey: "location")
        shop2.setValue("softlogic-img", forKey: "image")
        shop1.setValue(6.9037, forKey: "longtide")
        shop1.setValue(79.8521, forKey: "latitude")
        
        let shop3 = NSManagedObject(entity: entity!, insertInto: context)
        
        shop3.setValue(3, forKey: "id")
        shop3.setValue("Dinapala", forKey: "name")
        shop3.setValue("Colombo 05", forKey: "location")
        shop3.setValue("dinapala-img", forKey: "image")
        shop3.setValue(6.9038, forKey: "longtide")
        shop3.setValue(79.8522, forKey: "latitude")
        
        
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        
        
    }
    
    //getting all shops from db
    func getShopsDataFromDb(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Shops")
        request.returnsObjectsAsFaults = false
        
        do {
            resultfromDb = try context.fetch(request)
            
        } catch {
            
            print("Failed Fetching")
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (resultfromDb as! [NSManagedObject]).count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ShopTableViewCell = (self.showCaseTableView.dequeueReusableCell(withIdentifier: "shop_table_view_cell_identifier") as! ShopTableViewCell?)!
        
        
        cell.shopName.text = ((resultfromDb as! [NSManagedObject])[indexPath.row].value(forKey: "name") as! String)
        cell.shopLocation.text = ((resultfromDb as! [NSManagedObject])[indexPath.row].value(forKey: "location") as! String)
        cell.shopImg.image = UIImage(named: ((resultfromDb as! [NSManagedObject])[indexPath.row].value(forKey: "image") as! String))
      
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        selectedId = ((resultfromDb as! [NSManagedObject])[indexPath.row].value(forKey: "id")) as! Int
        performSegue(withIdentifier: "show_map", sender: self)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            
            var predicate: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "name BEGINSWITH[c] '\(searchText)'")
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Shops")
            fetchRequest.predicate = predicate
            do {
                resultfromDb = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
        }else{
            getShopsDataFromDb()
        }
        
        DispatchQueue.main.async {
            self.showCaseTableView.reloadData()
        }
       
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "show_map" ,
              let nextScene = segue.destination as? MapViewController {
                  nextScene.selectedId = selectedId
            
              
          }
          
      }
    
}

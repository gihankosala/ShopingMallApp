//
//  MapViewController.swift
//  OnlineShoppingMall
//
//  Created by Admin on 3/25/21.
//  Copyright © 2021 Admin. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {

    var selectedId = 0
    var lat = 0.0
    var lon = 0.0
    var name = ""
    var location =  ""
    
    @IBOutlet weak var shopsMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        getSelectedShopData()
        
        
    }
    
    func setUpNavigationBar(){
        //navigation bar
        //let backButton = UIBarButtonItem(image: UIImage(named: "back icn"), style: .plain, target: self, action: #selector(backButtonAction(_:)))
        //self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.green
        self.navigationItem.title = "Shop Location"
        
    }
    
    func getSelectedShopData(){
       
        //getting post data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Shops")
        request.predicate = NSPredicate(format: "id = %@", String(selectedId))
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            lat = ((result as! [NSManagedObject])[0].value(forKey: "latitude") as! Double)
            lon = ((result as! [NSManagedObject])[0].value(forKey: "longtide") as! Double)
            name = ((result as! [NSManagedObject])[0].value(forKey: "name") as! String)
            location = ((result as! [NSManagedObject])[0].value(forKey: "location") as! String)
            setupLocation()
            
            
        } catch {
            
            print("Failed")
        }
        
    }
    
    func setupLocation() {
         
         var c = CLLocationCoordinate2D()
         
         let latitude:Double = lat
         
         let longtude:Double = lon
         
         c.latitude = latitude
         c.longitude = longtude
         
         let a = MKPointAnnotation()
         a.coordinate = c
         a.title = name + ",\n" + location
         shopsMap.addAnnotation(a)
         shopsMap.setCenter(c, animated: true)
         
     }
    

   

}

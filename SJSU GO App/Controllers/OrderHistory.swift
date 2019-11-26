//
//  OrderHistory.swift
//  SJSU GO App
//
//  Created by Chanip Chong on 10/27/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import UIKit
import Firebase

class OrderHistory: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let activityIndicator = ActivityIndicator()
    
    @IBAction func Out(_ sender: Any)
    {
        self.view.removeFromSuperview()
    }
    var orders = [order]()
    var ref: DatabaseReference!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return(orders.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCellTableViewCell") as! orderCellTableViewCell
        
        /////set cell
        
        cell.orderName.text = orders[indexPath.row].name + "  " + orders[indexPath.row].size
        cell.orderImage.image = orders[indexPath.row].image
        cell.orderID.text =  orders[indexPath.row].ID
        cell.orderDate.text = orders[indexPath.row].Date
        cell.orderStatus.text = orders[indexPath.row].status
 
        ////
        return cell
    }
    

    @IBOutlet weak var HistoryTable: UITableView!
    override func viewDidLoad()
    {
        setBackgroundColors()
    
        HistoryTable.rowHeight = 100
        
        let orderCell = UINib(nibName: "orderCellTableViewCell", bundle: nil)
        HistoryTable.register(orderCell, forCellReuseIdentifier: "orderCellTableViewCell")
        HistoryTable.separatorStyle = .singleLine
        //load user's information
        let uid = Auth.auth().currentUser!.uid
        retrieveData(childName: uid)
    }
    
    func setBackgroundColors() {
        Colors.setLightBlueColor(view: self.view)
        Colors.setWarmYellowColor(view: HistoryTable)
    }
    
    public func retrieveData(childName: String )
    {
        activityIndicator.showActivityIndicator(self)
        
        ref = Database.database().reference().child("orders").child(childName)
        
        ref.observe(DataEventType.value, with:
            {
                (snapshot) in
                if snapshot.childrenCount>0
                {
                    for orders in snapshot.children.allObjects as![DataSnapshot]
                    {
                        let orderObject = orders.value as? [String: AnyObject]
                        let orderName = orderObject?["item"]
                        let orderDate = orderObject?["order date"]
                        let orderID = orders.key
                        let orderSize = orderObject?["size"]
                        let orderStatus = orderObject?["status"]
                        let orderImageUrl = orderObject?["imageURL"]
                        let orderPoint = orderObject?["points"]

                        if let URL = URL(string: orderImageUrl as! String)
                        {
                            do{
                                let data = try Data (contentsOf: URL)
                                let orderImage = UIImage(data: data)
                                let Order = order(image: orderImage!, name: orderName as! String, ID : orderID, size : orderSize as! String,date: orderDate as! String,point: orderPoint as! Int, status: orderStatus as! String )
                                print("successfully load order")
                                self.orders.append(Order)
                            }
                            catch let err
                            {
                                Alerts.showUpdateFailedAlertVC(on: self, message: err.localizedDescription)
                            }
                        }
                        
                    }
                }
                
                self.HistoryTable.reloadData()
                self.activityIndicator.hideActivityIndicator(self)
        })
        
        
    }

 
}

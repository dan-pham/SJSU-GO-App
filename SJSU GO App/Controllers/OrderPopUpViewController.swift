//
//  OrderPopUpViewController.swift
//  SJSU GO App
//
//  Created by Chanip Chong on 9/29/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import UIKit
import Firebase

class OrderPopUpViewController: UIViewController
{
    var userPoint = 0
    var afterPoints = 0
    var user = User()
    var prize = prizemodel();
    var prizeSize = "";
    var Tier = "";
    var stock = 1;
    var section = 0
    var row = 0
    @IBOutlet weak var Image: UIImageView!
    
    @IBOutlet weak var afterPoint: UILabel!
    @IBOutlet weak var UserPoint: UILabel!
    @IBOutlet weak var itemPoint: UILabel!
    @IBOutlet weak var name: UILabel!
    
    
    @IBAction func cancel(_ sender: Any)
    {
        leaveAnimate()
        
    }
    
    
    @IBAction func OK(_ sender: Any)
    {
        let uid = Auth.auth().currentUser!.uid

        let calendar = Calendar.current
        let year = String (calendar.component(.year, from: Date()))
        let month = String (calendar.component(.month, from: Date()))
        let day  = String (calendar.component(.day, from: Date()))
        let date =  year + " - " + month + " - " +  day
        let orderRef = UUID()
      
        // create an order sent to orders section in DB and also create a reference number copy to user's order histroy
        let name = user.firstName! + " " + user.lastName!
        let order = ["Buyer": name as AnyObject, "sjsu_id": user.sjsuId! as AnyObject, "item": prize.name as AnyObject, "size": prizeSize as AnyObject, "order date": date, "points": prize.point, "status": "incomplete :ordered", "imageURL": prize.imageURL] as [String: AnyObject]

        Database.database().reference().child("orders").child(uid).child(orderRef.uuidString).setValue(order)
        Database.database().reference().child("users").child(uid).child("points").setValue(afterPoints)
        
        let afterStock = prize.stock-1
        Database.database().reference().child("prizes").child(Tier).child(prize.name).child("stock").setValue(afterStock)
      
        
        
        let recipant = self.parent as! PrizeTableViewController
        recipant.reloadData(section: section, row: row);
        notification()
        leaveAnimate()
    }
    func notification ()
    {
        let alert = UIAlertController(title: "Congratulation", message: "Your order will be ready for pick up within 3 days,please pick up at Enginnering hall 235 room.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { ACTION in
            alert.dismiss(animated: true, completion: nil)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ///set data//
        afterPoints = userPoint - prize.point
        itemPoint.text = "\(prize.point)"
        name.text = prize.name + "  " + prizeSize
        Image.image = prize.image
        UserPoint.text = "\(userPoint)"
        afterPoint.text = "\(afterPoints)"
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        showAnimate()
        
    }
    func showAnimate()
    {
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 1.0
            
        })
        
    }
    
    func leaveAnimate()
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 0.0;

        }, completion: {(finised : Bool) in
            if (finised)
            { self.view.removeFromSuperview()
            }
            
        })
        
    }
}

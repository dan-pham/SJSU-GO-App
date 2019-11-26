 //
//  PrizeTableViewController.swift
//  SJSU GO App
//
//  Created by Chanip Chong on 9/13/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import UIKit
import Firebase

 struct CellData
 {
    var expanded = Bool();
    var title = String();
    var Cells = [prizemodel]();
 }

class PrizeTableViewController: UITableViewController
{
    let tier1Points = 30
    let tier2Points = 60
    let tier3Points = 100

    var user = User()
    var tableData = [CellData]()
    var prizeList = [prizemodel]()
    var ref: DatabaseReference!
    var points = 0
    var status = String()
    var section = String()
    
    let activityIndicator = ActivityIndicator()
    
    @IBOutlet var PrizeTable: UITableView!
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBackgroundColors()
        if section == "closed" {
            Alerts.showPrizeSessionClosedAlertVC(on: self)
        }
    }
    
    override func viewDidLoad() {
          
        // check if priceSection open
        ref = Database.database().reference()
          
        //activityIndicator.showActivityIndicator()
        ref.observeSingleEvent(of: .value) { (snapshot) in
              
            if let dictionary = snapshot.value as? [String: AnyObject] {
                  self.section = dictionary["PrizeSession"] as? String ?? ""

                  if (self.section == "open") {
                      ////
                      //self.activityIndicator.showActivityIndicator()
                      
                      self.PrizeTable.dataSource = self
                      self.PrizeTable.delegate = self
                      self.PrizeTable.separatorStyle = .none
                      // set backgroud of tableView
                      /*
                       let backgroundImage = UIImage(named: "sjsu_go_logo")
                       let imageView = UIImageView(image: backgroundImage)
                       self.tableView.backgroundView = imageView
                       */
                      
                      /// declare the cell types that going to use
                      let TierCell = UINib(nibName: "TierCell", bundle: nil)
                      self.PrizeTable.register(TierCell, forCellReuseIdentifier: "TierCell")
                      
                      let clothingCell = UINib(nibName: "clothingPrizeCell", bundle: nil)
                      self.PrizeTable.register(clothingCell, forCellReuseIdentifier: "clothingPrizeCell")
                      
                      let OtherCell = UINib(nibName: "OtherCell", bundle: nil)
                      self.PrizeTable.register(OtherCell, forCellReuseIdentifier: "OtherCell")
                      
                      //load user's information
                      let uid = Auth.auth().currentUser!.uid
                      self.ref = Database.database().reference().child("users").child(uid)
                      
                      self.activityIndicator.showActivityIndicator(self)
                      
                      self.ref.observeSingleEvent(of: .value) { (snapshot) in
                          
                          if let dictionary = snapshot.value as? [String: AnyObject]
                          {
                              print (dictionary)
                              self.user.firstName = dictionary["first_name"] as? String
                              self.user.lastName = dictionary["last_name"] as? String
                              self.user.major = dictionary["major"] as? String
                              self.user.email = dictionary["sjsu_email"] as? String
                              self.user.academicYear = dictionary["academic_year"] as? String
                              self.user.sjsuId = dictionary["sjsu_id"] as? String
                              self.user.points = dictionary["points"] as? Int ?? 0
                              self.points = dictionary["points"] as? Int ?? 0
                          }
                      }
                      
                      self.retrieveData(childName: "Tier1")
                      self.retrieveData(childName: "Tier2")
                      self.retrieveData(childName: "Tier3")
                      
                      self.activityIndicator.hideActivityIndicator(self)
                      
                  } else {
                      // it is closed
                      let alert = UIAlertController(title: "Session is Closed", message: "Prize Session is curretly closed, the time for reopen will be posted later. check back later!", preferredStyle: UIAlertController.Style.alert)
                      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { ACTION in
                          alert.dismiss(animated: true, completion: nil)
                          
                      }))
                      self.present(alert, animated: true, completion: nil)
                  }
              }
          }
        
          // Uncomment the following line to preserve selection between presentations
          // self.clearsSelectionOnViewWillAppear = false
          // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
          // self.navigationItem.rightBarButtonItem = self.editButtonItem
      }
    
    func setBackgroundColors() {
        Colors.setLightBlueColor(view: self.view)
    }


    // MARK: - Table view data source

    override func numberOfSections(in prizeTable: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tableData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if the section is expanded, then show the rows
        if tableData[section].expanded == true
        {
            return tableData[section].Cells.count + 1
        }
        else
        {
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TierCell")as! TierCell
        
            cell.Title?.text = tableData[indexPath.section].title 
            cell.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 5
            cell.layer.borderWidth = 2
            cell.layer.shadowOffset = CGSize(width: 2, height: 3)
            cell.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            return cell
        }
            
        // Configure the cell...
        else
        {
            
            
            if tableData[indexPath.section].Cells[indexPath.row-1].category == "clothing"
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "clothingPrizeCell") as! clothingPrizeCell
                
                cell.name.text = tableData[indexPath.section].Cells[indexPath.row-1].name
                cell.prizeImage.image = tableData[indexPath.section].Cells[indexPath.row-1].image
                //// check if the user can buy this item or not

                if tableData[indexPath.section].Cells[indexPath.row-1].stock == 0
                {
                    cell.claimButton.setTitle("Out of Stock", for: .normal)
                    cell.claimButton.isEnabled = false
                }
                if cell.status == "none"
                {
                    cell.claimButton.isEnabled = false
                }
                ////check if the user has enough points
                if (indexPath.section == 0)
                {
                    if self.points < tier1Points
                    {
                        cell.buttonDisable();
                    }
                }
                else if (indexPath.section == 1)
                {
                    if self.points < tier2Points
                    {
                        cell.buttonDisable();
                    }
                }
                else if (indexPath.section == 2)
                {
                    if self.points < tier3Points
                    {
                        cell.buttonDisable();
                    }
                }
                
                // claim button function here
                cell.claimButtonAction =
                    {[unowned self] in
                    let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"OrderPopUpViewController") as!OrderPopUpViewController
                    self.addChild(popUpVC)
                    popUpVC.view.frame = self.view.frame
                    self.view.addSubview(popUpVC.view)
                    
                    popUpVC.prize = self.tableData[indexPath.section].Cells[indexPath.row-1]
                    popUpVC.userPoint = self.points
                    popUpVC.prizeSize = cell.status
                    popUpVC.user = self.user
                    popUpVC.Tier = self.tableData[indexPath.section].title
                    popUpVC.section = indexPath.section
                    popUpVC.row = indexPath.row-1

                        //////
                        // go to orderPopUp view
                        popUpVC.viewDidLoad()
                        popUpVC.didMove(toParent: self)
                        
                }
                cell.layer.masksToBounds = true
                cell.layer.cornerRadius = 5
                cell.layer.borderWidth = 2
                cell.layer.shadowOffset = CGSize(width: 2, height: 3)
                cell.layer.borderColor = #colorLiteral(red: 0.8588768244, green: 0.9472774863, blue: 1, alpha: 1)
                return cell
                
            }
                
           // else if tableData[indexPath.section].Cells[indexPath.row-1].category == "none"
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OtherCell") as! OtherCell
                
                cell.name.text = tableData[indexPath.section].Cells[indexPath.row-1].name
                cell.prizeImage.image = tableData[indexPath.section].Cells[indexPath.row-1].image
                
                //// check if the user can buy this item or not
                if tableData[indexPath.section].Cells[indexPath.row-1].stock == 0
                {
                    cell.claimButton.setTitle("Out of Stock", for: .normal)
                    cell.claimButton.isEnabled = false
                }
                ////check if the user has enough points
                if (indexPath.section == 0)
                {
                    if self.points < tier1Points
                    {
                        cell.claimButton.isEnabled = false;
                    }
                }
                else if (indexPath.section == 1)
                {
                    if self.points < tier2Points
                    {
                        cell.claimButton.isEnabled = false;
                    }
                }
                else if (indexPath.section == 2)
                {
                    if self.points < tier3Points
                    {
                        cell.claimButton.isEnabled = false;
                    }
                }
 
                // claim button function here
                cell.claimButtonAction =
                    {
                    [unowned self] in
                    let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"OrderPopUpViewController") as!OrderPopUpViewController
                    self.addChild(popUpVC)
                    popUpVC.view.frame = self.view.frame
                    self.view.addSubview(popUpVC.view)
                    
                    popUpVC.prize = self.tableData[indexPath.section].Cells[indexPath.row-1]
                    popUpVC.userPoint = self.points
                    popUpVC.user = self.user
                    popUpVC.Tier = self.tableData[indexPath.section].title
                    popUpVC.section = indexPath.section
                    popUpVC.row = indexPath.row-1
                        // go to orderPopUp view
                        popUpVC.viewDidLoad()
                        popUpVC.didMove(toParent: self)
                        
                    }

                cell.layer.masksToBounds = true
                cell.layer.cornerRadius = 5
                cell.layer.borderWidth = 2
                cell.layer.shadowOffset = CGSize(width: 2, height: 3)
                cell.layer.borderColor = #colorLiteral(red: 0.8588768244, green: 0.9472774863, blue: 1, alpha: 1)
                return cell
            }
            
        }
        
       
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0
        {
            UIView.animate(withDuration: 0.5, animations:
                {
                    if self.tableData[indexPath.section].expanded == true
                    {
                        self.tableData[indexPath.section].expanded = false
                        let sections = IndexSet.init(integer: indexPath.section)
                        tableView.reloadSections(sections, with: .none)
                    }
                    else
                    {
                        self.tableData[indexPath.section].expanded = true
                        let sections = IndexSet.init(integer: indexPath.section)
                        tableView.reloadSections(sections, with: .none)
                    }
                
            }, completion: {(finished:Bool) in
                
            })
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return 50
            
        }
        else
        {
        return 150
        }
    }
    
    public func reloadData(section: Int , row: Int)
    {
        
        print("reloading")
        //update info from DB, only stock and user's point
        // or you can reload data from BS
        self.tableData[section].Cells[row].stock -= 1
        self.points -= self.tableData[section].Cells[row].point
        /*
        let uid = Auth.auth().currentUser!.uid
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value)
        { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                self.points = dictionary["points"] as? Int ?? 0
            }
        }
        */
        //
    //Database.database().reference().child("prizes").child(self.tableData[section].title).child(self.tableData[section].Cells[row].name).child("stock").setValue(self.tableData[section].Cells[row].stock)
        PrizeTable.reloadData()
    }
    // to get data from DB and put them in tableData
    public func retrieveData(childName: String )
    {
        ref = Database.database().reference().child("prizes").child(childName)
       
        ref.observeSingleEvent(of: DataEventType.value, with:
            {
                (snapshot) in
                if snapshot.childrenCount>0
                {
                    for prizes in snapshot.children.allObjects as![DataSnapshot]
                    {
                        
                        let prizeObject = prizes.value as? [String: AnyObject]
                    
                        let prizeName = prizeObject?["name"]
                        let prizeDescription = prizeObject?["description"]
                        let prizeImageUrl = prizeObject?["imageUrl"]
                        let prizeStock = prizeObject?["stock"]
                        let prizeCategory = prizeObject?["category"]
                        let prizePoint = prizeObject?["point"]
                        if let URL = URL(string: prizeImageUrl as! String)
                        {
                            
                            do{
                                let data = try Data (contentsOf: URL)
                                let prizeImage = UIImage(data: data)
                                
                                let prize = prizemodel(image: prizeImage!, name: prizeName as! String, description: prizeDescription as! String, category: prizeCategory as! String, stock: prizeStock as! Int, point: prizePoint as! Int, URL: prizeImageUrl as! String)
                                
                                print("successfully ")
                                self.prizeList.append(prize)
                            }
                            catch let err
                            {
                                self.activityIndicator.hideActivityIndicator(self)
                                Alerts.showUpdateFailedAlertVC(on: self, message: err.localizedDescription)
                            }
                        }
                        
                    }
                }
                
                let add = CellData(expanded: false,title: childName,Cells: self.prizeList )
                self.tableData.append(add)
                self.prizeList.removeAll()
                self.PrizeTable.reloadData()
        
        })
     

    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

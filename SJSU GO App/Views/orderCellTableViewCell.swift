//
//  orderCellTableViewCell.swift
//  SJSU GO App
//
//  Created by Chanip Chong on 10/27/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import UIKit

class orderCellTableViewCell: UITableViewCell
{

    @IBOutlet weak var orderID: UITextField!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Colors.setWarmYellowColor(view: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  OtherCell.swift
//  SJSU GO App
//
//  Created by Chanip Chong on 9/29/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import UIKit

class OtherCell: UITableViewCell {

    @IBOutlet weak var prizeImage: UIImageView!
    
    @IBOutlet weak var claimButton: UIButton!
    @IBOutlet weak var name: UILabel!
    
    var claimButtonAction : (() -> ())?
    @IBAction func Claim(_ sender: UIButton)
    {
        claimButtonAction?()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

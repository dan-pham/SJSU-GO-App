//
//  prizeDisplay.swift
//  SJSU GO App
//
//  Created by Chanip Chong on 9/13/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import UIKit

class clothingPrizeCell: UITableViewCell
{
    var status = "none"
    @IBOutlet weak var XS: UIButton!
    @IBOutlet weak var S: UIButton!
    @IBOutlet weak var M: UIButton!
    @IBOutlet weak var L: UIButton!
    @IBOutlet weak var XL: UIButton!
    @IBOutlet weak var XXL: UIButton!
    
    @IBOutlet weak var claimButton: UIButton!
    var claimButtonAction : (() -> ())?

    @IBAction func Claim(_ sender: UIButton)
    {
       claimButtonAction?()
    }
    
    
    @IBAction func XS(_ sender: Any)
    {
        if XS.isSelected
        {
            status = "none"
            claimButton.isEnabled = false
            XS.isSelected = !XS.isSelected
        }
        else
        {
            status = "XS"
            XS.isSelected = !XS.isSelected
            S.isSelected = false;
            XL.isSelected = false;
            M.isSelected = false;
            L.isSelected = false;
            XXL.isSelected = false;
            claimButton.isEnabled = true

        }
    }
    
    @IBAction func S(_ sender: Any)
    {
        if S.isSelected
        {
            status = "none"
            claimButton.isEnabled = false

            S.isSelected = !S.isSelected
        }
        else
        {
            status = "S"
            S.isSelected = !S.isSelected
            claimButton.isEnabled = true

            XS.isSelected = false;
            XL.isSelected = false;
            M.isSelected = false;
            L.isSelected = false;
            XXL.isSelected = false;
        }

    }
    
  
    @IBAction func M(_ sender: Any)
    {
        if M.isSelected
        {
            status = "none"
            claimButton.isEnabled = false

            M.isSelected = !M.isSelected
        }
        else
        {
            
            status = "M"
            M.isSelected = !M.isSelected
            claimButton.isEnabled = true

            XS.isSelected = false;
            S.isSelected = false;
            XL.isSelected = false;
            L.isSelected = false;
            XXL.isSelected = false;
        }

    }
    
    @IBAction func L(_ sender: Any)
    {
        if L.isSelected
        {
            claimButton.isEnabled = false

            status = "none"
            L.isSelected = !L.isSelected
        }
        else
        {
            status = "L"
            L.isSelected = !L.isSelected
            claimButton.isEnabled = true

            XS.isSelected = false;
            S.isSelected = false;
            M.isSelected = false;
            XL.isSelected = false;
            XXL.isSelected = false;
        }

    }
    
    @IBAction func XL(_ sender: Any)
    {
        
        if XL.isSelected
        {
            status = "none"
            claimButton.isEnabled = false

            XL.isSelected = !XL.isSelected
        }
        else
        {
            status = "XL"
            XL.isSelected = !XL.isSelected
            claimButton.isEnabled = true

            XS.isSelected = false;
            S.isSelected = false;
            M.isSelected = false;
            L.isSelected = false;
            XXL.isSelected = false;
        }

    }
   
    @IBAction func XXL(_ sender: Any)
    {
        if XXL.isSelected
        {
            XXL.isSelected = !XXL.isSelected
            claimButton.isEnabled = false

            status = "none"
        }
        else
        {
            claimButton.isEnabled = true

            status = "XXL"
            XXL.isSelected = !XXL.isSelected
            
            XS.isSelected = false;
            S.isSelected = false;
            M.isSelected = false;
            L.isSelected = false;
            XL.isSelected = false;
        }


    }
    func buttonDisable()
    {
        XS.isEnabled = false
        S.isEnabled = false
        M.isEnabled = false
        L.isEnabled = false
        XL.isEnabled = false
        XXL.isEnabled = false
        claimButton.isEnabled = false

    }
    @IBOutlet weak var prizeImage: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
  
}

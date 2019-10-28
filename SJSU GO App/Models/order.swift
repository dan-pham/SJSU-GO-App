//
//  order.swift
//  SJSU GO App
//
//  Created by Chanip Chong on 10/27/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import Foundation
import UIKit

class order
{
    var image : UIImage
    var name : String
    var ID : String
    var size : String
    var Date: String
    var point: Int
    var status: String
    init ()
    {
        self.image = UIImage()
        self.name = ""
        self.ID = ""
        self.size = ""
        self.Date = "4"
        self.point = 5
        self.status = ""
    }
    init (image: UIImage, name: String, ID : String, size : String,date: String,point: Int, status: String)
    {
        self.image = image
        self.name = name
        self.ID = ID
        self.size = size
        self.Date = date
        self.point = point
        self.status = status
    }
}

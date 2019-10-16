//
//  prizemodel.swift
//  dropdown
//
//  Created by Chanip Chong on 9/9/19.
//  Copyright © 2019 sjsu. All rights reserved.
//

import Foundation
import UIKit

class prizemodel{
    var image : UIImage
    var name : String
    var description : String
    var category : String
    var stock: Int
    var point: Int
    init ()
    {
        self.image = UIImage()
        self.name = ""
        self.description = ""
        self.category = ""
        self.stock = 4
        self.point = 5
    }
    init (image: UIImage, name: String, description : String, category : String,stock: Int,point: Int)
    {
        self.image = image
        self.name = name
        self.description = description
        self.category = category
        self.stock = stock
        self.point = point
    }
}

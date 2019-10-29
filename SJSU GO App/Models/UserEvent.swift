//
//  UserEvent.swift
//  SJSU GO App
//
//  Created by Dan Pham on 8/20/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import UIKit

class UserEvent: NSObject {
    var user: User?
    var id: String?
    var title: String?
    var eventType: String?
    var eventDescription: String?
    var points: Int?
    var date: Date?
    var isApprovedByAdmin: String?
    var image: UIImage?
}

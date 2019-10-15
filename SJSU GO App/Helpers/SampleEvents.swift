//
//  SampleEvents.swift
//  SJSU GO App
//
//  Created by Dan Pham on 8/19/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import UIKit

class SampleAdminEvents {
    
    static var sharedInstance = SampleAdminEvents()
    
    var adminEvents = [AdminEvent]()
    
    func setupAdminEvents() {
        let adminEvent1 = AdminEvent()
        adminEvent1.title = "STEM Career Fair"
        adminEvent1.eventType = "Attend a campus event"
        adminEvent1.eventDescription = "Engineering Career Fair"
        adminEvent1.points = 5
        
        let adminEvent2 = AdminEvent()
        adminEvent2.eventType = "Join a student club/society"
        adminEvent2.eventDescription = "Society of Women in Engineering"
        adminEvent2.points = 10
        
        let adminEvent3 = AdminEvent()
        adminEvent3.eventType = "Participate in MESA"
        adminEvent3.eventDescription = "Joined MESA"
        adminEvent3.points = 15
        
        let adminEvent4 = AdminEvent()
        adminEvent4.eventType = "Create a LinkedIn profile"
        adminEvent4.eventDescription = "Created my LinkedIn profile"
        adminEvent4.points = 5
        
        let adminEvent5 = AdminEvent()
        adminEvent5.eventType = "BRAVEN, GTI, and Study Abroad Programs"
        adminEvent5.eventDescription = "Complete the BRAVEN, GTI, or any Engineering Study Abroad program with a passing grade"
        adminEvent5.points = 60
        
        adminEvents = [adminEvent1, adminEvent2, adminEvent3, adminEvent4, adminEvent5]
    }
    
}

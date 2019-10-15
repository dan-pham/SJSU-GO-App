//
//  UserEventCell.swift
//  SJSU GO App
//
//  Created by Dan Pham on 8/21/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import UIKit

class UserEventCell: UITableViewCell {
    
    var event: UserEvent? {
        didSet {
            textLabel?.text = event?.eventType
            detailTextLabel?.text = event?.eventDescription
            
            if let image = event?.image {
                eventImageView.image = image
            } else {
                eventImageView.image = UIImage(named: "defaultPlaceholderImage")
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.superview!.frame.width - 72, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.superview!.frame.width - 72, height: detailTextLabel!.frame.height)
    }
    
    let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(eventImageView)
        
        // x, y, width, height anchors
        eventImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        eventImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        eventImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        eventImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

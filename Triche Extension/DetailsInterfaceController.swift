//
//  DetailsInterfaceController.swift
//  MacTriche
//
//  Created by Thomas Mac on 09/07/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import WatchKit
import Foundation


class DetailsInterfaceController: WKInterfaceController {
    
    @IBOutlet private var label: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        self.setTitle((context as! NSDictionary)["title"] as? String)
        
        self.label.setText((context as! NSDictionary)["data"] as? String)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

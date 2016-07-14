//
//  InterfaceController.swift
//  Triche Extension
//
//  Created by Thomas Mac on 08/07/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    private let sauvegarde = NSUserDefaults()
    
    @IBOutlet private var table: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        self.setTitle("Main Menu")
        
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        if (WCSession.defaultSession().reachable) {
            //This means the companion app is reachable
        }
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        let data = ["data" : "getData"]
        
        WCSession.defaultSession().sendMessage(data, replyHandler: { (_: [String : AnyObject]) -> Void in }, errorHandler: { (NSError) -> Void in })
        
        self.setTable()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    private func setTable()
    {
        self.table.setNumberOfRows(self.sauvegarde.integerForKey("numberOfItems"), withRowType:"row")
        
        var i = 0
        while (i < self.sauvegarde.integerForKey("numberOfItems"))
        {
            let row = self.table.rowControllerAtIndex(i) as! TextRow
            row.label.setText(self.sauvegarde.stringForKey("titleOfItemN°" + String(i)))
            i += 1
        }
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        self.sauvegarde.removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
        
        self.sauvegarde.setInteger(message.count / 2, forKey:"numberOfItems")
        
        var i = 0
        var indice = 0
        while (i < message.count)
        {
            self.sauvegarde.setObject(message["contenuOfItemN°" + String(indice)]!, forKey:"contenuOfItemN°" + String(indice))
            self.sauvegarde.setObject(message["titleOfItemN°" + String(indice)]!, forKey:"titleOfItemN°" + String(indice))
            
            i += 2
            indice += 1
        }
        self.sauvegarde.synchronize()
        self.setTable()
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        let title : String = self.sauvegarde.stringForKey("titleOfItemN°" + String(rowIndex))!
        let data : String = self.sauvegarde.stringForKey("contenuOfItemN°" + String(rowIndex))!
        self.presentControllerWithName("detailsInterface", context:["title" : title, "data" : data])
    }

}

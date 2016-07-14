//
//  MainTableViewController.swift
//  MacTriche
//
//  Created by Thomas Mac on 08/07/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit
import WatchConnectivity

class MainTableViewController: UITableViewController, WCSessionDelegate {

    private let sauvegarde = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.tableView.registerClass(TableViewCellWithTwoButtons.classForCoder(), forCellReuseIdentifier:"cell")
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier:"cell1")
        
        self.title = "Mac Triche"
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.8)
        shadow.shadowOffset = CGSizeMake(0, 1)
        
        let addItemButton = UIBarButtonItem(title:"+", style:UIBarButtonItemStyle.Done, target:self, action:#selector(self.addItemButtonActionListener))
        addItemButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:30.0)!], forState:UIControlState.Normal)
        
        self.navigationItem.rightBarButtonItem = addItemButton
        
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        if (WCSession.defaultSession().reachable) {
            //This means the companion app is reachable
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func addItemButtonActionListener()
    {
        let alertController = UIAlertController(title:"Ajout d'un aide mémoire", message:"Entrez un titre et le contenu de votre aide mémoire.", preferredStyle:.Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "titre de l'aide mémoire"
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "contenu de l'aide mémoire"
        }
        let alertActionOne = UIAlertAction(title:"OK", style:.Default) { (_) in
            let titleTextField = alertController.textFields![0]
            let contenuTextField = alertController.textFields![1]
            if (!titleTextField.hasText() || !contenuTextField.hasText())
            {
                self.addItemButtonActionListener()
                return
            }
            self.sauvegarde.setObject(contenuTextField.text, forKey:"contenuOfItemN°" + String(self.sauvegarde.integerForKey("numberOfItems")))
            self.sauvegarde.setObject(titleTextField.text, forKey:"titleOfItemN°" + String(self.sauvegarde.integerForKey("numberOfItems")))
            self.sauvegarde.setInteger(self.sauvegarde.integerForKey("numberOfItems") + 1, forKey:"numberOfItems")
            self.sauvegarde.synchronize()
            self.tableView.reloadData()
            self.sendData()
        }
        let alertActionTwo = UIAlertAction(title:"Annuler", style:.Default) { (_) in }
        
        alertController.addAction(alertActionOne)
        alertController.addAction(alertActionTwo)
        
        self.presentViewController(alertController, animated:true, completion:nil)
    }
    
    private func sendData()
    {
        let dictionnaire = NSMutableDictionary()
        
        var i = 0
        while (i < self.sauvegarde.integerForKey("numberOfItems"))
        {
            dictionnaire.setObject(self.sauvegarde.stringForKey("titleOfItemN°" + String(i))!, forKey:"titleOfItemN°" + String(i))
            dictionnaire.setObject(self.sauvegarde.stringForKey("contenuOfItemN°" + String(i))!, forKey:"contenuOfItemN°" + String(i))
            i += 1
        }
        
        let data = NSDictionary(dictionary:dictionnaire)
        
        WCSession.defaultSession().sendMessage(data as! [String : AnyObject], replyHandler: { (_: [String : AnyObject]) -> Void in }, errorHandler: { (NSError) -> Void in })
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        self.sendData()
    }

    internal func modifyItemAtIndex(index: Int)
    {
        let alertController = UIAlertController(title:"Modification d'un aide mémoire", message:"Entrez un titre et le contenu de votre aide mémoire.", preferredStyle:.Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "titre de l'aide mémoire"
            textField.text = self.sauvegarde.stringForKey("titleOfItemN°" + String(index))
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "contenu de l'aide mémoire"
            textField.text = self.sauvegarde.stringForKey("contenuOfItemN°" + String(index))
        }
        let alertActionOne = UIAlertAction(title:"OK", style:.Default) { (_) in
            let titleTextField = alertController.textFields![0]
            let contenuTextField = alertController.textFields![1]
            if (!titleTextField.hasText() || !contenuTextField.hasText())
            {
                self.modifyItemAtIndex(index)
                return
            }
            self.sauvegarde.setObject(contenuTextField.text, forKey:"contenuOfItemN°" + String(index))
            self.sauvegarde.setObject(titleTextField.text, forKey:"titleOfItemN°" + String(index))
            self.sauvegarde.synchronize()
            self.tableView.reloadData()
            self.sendData()
        }
        let alertActionTwo = UIAlertAction(title:"Annuler", style:.Default) { (_) in }
        
        alertController.addAction(alertActionOne)
        alertController.addAction(alertActionTwo)
        
        self.presentViewController(alertController, animated:true, completion:nil)
    }
    
    internal func removeItemAtIndex(index: Int)
    {
        let alertController = UIAlertController(title:"Suppression d'un aide mémoire", message:"Êtes-vous sûr de vouloir supprimer cette aide mémoire ?", preferredStyle:.Alert)
        
        let alertActionOne = UIAlertAction(title:"Oui", style:.Default) { (_) in
            var i = index
            while (i < self.sauvegarde.integerForKey("numberOfItems") - 1)
            {
                self.sauvegarde.setObject(self.sauvegarde.stringForKey("titleOfItemN°" + String(i + 1)), forKey:"titleOfItemN°" + String(i))
                self.sauvegarde.setObject(self.sauvegarde.stringForKey("contenuOfItemN°" + String(i + 1)), forKey:"contenuOfItemN°" + String(i))
                i += 1
            }
            self.sauvegarde.removeObjectForKey("titleOfItemN°" + String(i))
            self.sauvegarde.removeObjectForKey("contenuOfItemN°" + String(i))
            self.sauvegarde.setInteger(self.sauvegarde.integerForKey("numberOfItems") - 1, forKey:"numberOfItems")
            self.sauvegarde.synchronize()
            self.tableView.reloadData()
            self.sendData()
        }
        
        let alertActionTwo = UIAlertAction(title:"Non", style:.Default) { (_) in }
        
        alertController.addAction(alertActionOne)
        alertController.addAction(alertActionTwo)
        
        self.presentViewController(alertController, animated:true, completion:nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if (self.sauvegarde.integerForKey("numberOfItems") == 0)
        {
            return 1
        }
        return self.sauvegarde.integerForKey("numberOfItems")
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75.0
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (self.sauvegarde.integerForKey("numberOfItems") == 0)
        {
            return 0
        }
        let label = UILabel()
        label.text = self.sauvegarde.stringForKey("titleOfItemN°" + String(section))
        label.textColor = UIColor.blackColor()
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        label.backgroundColor = UIColor.lightTextColor()
        label.font = UIFont.boldSystemFontOfSize(16.0)
        
        label.sizeToFit()
        
        return label.frame.size.height + 10.0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (self.sauvegarde.integerForKey("numberOfItems") == 0)
        {
            return UILabel()
        }
        let label = UILabel()
        label.text = "    " + self.sauvegarde.stringForKey("titleOfItemN°" + String(section))!
        label.textColor = UIColor.blackColor()
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        label.backgroundColor = UIColor.lightTextColor()
        label.font = UIFont.boldSystemFontOfSize(16.0)
        
        label.sizeToFit()
        
        return label
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (self.sauvegarde.integerForKey("numberOfItems") == 0)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath)
            
            cell.textLabel?.text = "Aucune aide mémoire enregistrée"
            
            cell.textLabel?.textAlignment = .Center
            
            cell.selectionStyle = .None
            
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCellWithTwoButtons

        cell.textView.text = self.sauvegarde.stringForKey("contenuOfItemN°" + String(indexPath.section))
        
        cell.selectionStyle = .None
        
        cell.imageView?.image = UIImage(named:NSLocalizedString("ICON_MEMORY", comment:""))
        
        cell.indice = indexPath.section
        
        cell.mainTableViewController = self
        
        return cell
    }

}

//
//  TableViewCellWithTwoButtons.swift
//  CellLibrary
//
//  Created by Thomas Mac on 06/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

class TableViewCellWithTwoButtons: UITableViewCell {

    internal let buttonOne = UIButton(type: UIButtonType.RoundedRect)
    internal let buttonTwo = UIButton(type: UIButtonType.RoundedRect)
    
    internal let textView = UITextView()
    
    internal var indice = -1
    
    internal var mainTableViewController = MainTableViewController()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let decalage = CGFloat(10.0)
        
        self.buttonTwo.frame = CGRectMake(self.frame.size.width - decalage - 3 * self.frame.size.height / 4, decalage, 3 * self.frame.size.height / 4, self.frame.size.height - 2 * decalage)
        self.buttonTwo.titleLabel?.hidden = true
        self.buttonTwo.setBackgroundImage(UIImage(named:NSLocalizedString("ICON_SUPPR", comment:"")), forState:.Normal)
        self.buttonTwo.addTarget(self, action:#selector(self.buttonTwoActionListener), forControlEvents:UIControlEvents.TouchUpInside)
        
        self.buttonOne.frame = CGRectMake(self.buttonTwo.frame.origin.x - decalage - self.buttonTwo.frame.size.width, self.buttonTwo.frame.origin.y, self.buttonTwo.frame.size.width, self.buttonTwo.frame.size.height)
        self.buttonOne.titleLabel?.hidden = true
        self.buttonOne.setBackgroundImage(UIImage(named:NSLocalizedString("ICON_MODIFIER", comment:"")), forState:.Normal)
        self.buttonOne.addTarget(self, action:#selector(self.buttonOneActionListener), forControlEvents:UIControlEvents.TouchUpInside)
        
        self.imageView?.hidden = true
        
        self.textLabel?.hidden = true
        
        self.textView.frame = CGRectMake(decalage, 0.0, self.frame.size.width - 4 * decalage - self.buttonOne.frame.width - self.buttonTwo.frame.width, self.frame.size.height)
        self.textView.hidden = false
        self.textView.editable = false
        
        self.layer.borderColor = UIColor(red:213.0/255.0, green:210.0/255.0, blue:199.0/255.0, alpha:1.0).CGColor
        
        self.layer.borderWidth = 2.5
        self.layer.cornerRadius = 7.5
        self.layer.shadowOffset = CGSizeMake(0, 1)
        self.layer.shadowColor = UIColor.lightGrayColor().CGColor
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 0.8
        self.layer.masksToBounds = false
        
        self.addSubview(self.buttonOne)
        self.addSubview(self.buttonTwo)
        self.addSubview(self.textView)
    }
    
    @objc private func buttonOneActionListener()
    {
        self.mainTableViewController.modifyItemAtIndex(self.indice)
    }
    
    @objc private func buttonTwoActionListener()
    {
        self.mainTableViewController.removeItemAtIndex(self.indice)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

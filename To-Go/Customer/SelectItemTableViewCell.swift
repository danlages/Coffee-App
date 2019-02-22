//
//  SelectItemTableViewCell.swift
//  To-Go
//
//  Created by Daniel Lages on 09/06/2018.
//  Copyright © 2018 To-Go. All rights reserved.
//

import UIKit

class SelectItemTableViewCell: UITableViewCell {

    //MARK: Properties
    
    @IBOutlet weak var menuItemName: UILabel!
    @IBOutlet weak var menuItemPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        menuItemName.textColor = UIColor.black
        menuItemPrice.textColor = UIColor.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

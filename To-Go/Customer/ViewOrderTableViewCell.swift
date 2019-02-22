//
//  ViewOrderTableViewCell.swift
//  To-Go
//
//  Created by Sophie Traynor on 23/09/2018.
//  Copyright © 2018 To-Go. All rights reserved.
//

import UIKit

class ViewOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemSize: UILabel!
    @IBOutlet weak var itemCost: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        itemName.textColor = UIColor.black
        itemSize.textColor = UIColor.black
        itemCost.textColor = UIColor.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

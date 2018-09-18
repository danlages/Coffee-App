//
//  ViewOrderTableViewCell.swift
//  To-Go
//
//  Created by Sophie Traynor on 17/09/2018.
//  Copyright © 2018 To-Go. All rights reserved.
//

import UIKit

class ViewOrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemSize: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

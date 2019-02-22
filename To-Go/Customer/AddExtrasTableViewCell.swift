//
//  AddExtrasTableViewCell.swift
//  To-Go
//
//  Created by Sophie Traynor on 14/08/2018.
//  Copyright © 2018 To-Go. All rights reserved.
//

import UIKit

class AddExtrasTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    @IBOutlet weak var extra: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        extra.textColor = UIColor.black
        price.textColor = UIColor.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  AccountManagerTableViewCell.swift
//  TTS_Words&Weather
//
//  Created by Trevonte Dixon on 3/29/17.
//  Copyright © 2017 1umbrella. All rights reserved.
//

import UIKit

class AccountManagerTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "accountCell"

    
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var desctiptionLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

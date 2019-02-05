//
//  PinTableViewCell.swift
//  spotsaver
//
//  Created by Thomas Varano on 11/25/18.
//  Copyright © 2018 Thomas Varano. All rights reserved.
//

import UIKit

class PinTableViewCell: UITableViewCell {

    var pin: Pin!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let sLength = self.frame.height
        let maxX = self.frame.maxX
        appleMaps.frame = CGRect(x: maxX - 10 - sLength, y: 0, width: sLength, height: sLength)
        googleMaps.frame = CGRect(x: appleMaps.frame.minX - sLength - 10, y: 0, width: sLength, height: sLength)
        nameLabel.text = pin.name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var appleMaps: UIButton!
    @IBOutlet weak var googleMaps: UIButton!
}

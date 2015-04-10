//
//  photoCell.swift
//  instagram
//
//  Created by Bryan McLellan on 4/9/15.
//  Copyright (c) 2015 Bryan McLellan. All rights reserved.
//

import UIKit

class photoCell: UITableViewCell {

    @IBOutlet weak var photoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

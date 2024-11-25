//
//  HerosTableViewCell.swift
//  KCDragonBallProf
//
//  Created by EScode on 21/11/24.
//

import UIKit

class HerosTableViewCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

//
//  DataTableViewCell.swift
//  FlupperTest
//
//  Created by Sunil Kumar on 13/08/20.
//  Copyright © 2020 UttamTech. All rights reserved.
//

import UIKit

class DataTableViewCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var imagetoUrl: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imagetoUrl.layer.masksToBounds = true
        imagetoUrl.clipsToBounds = true
        imagetoUrl.contentMode = .scaleAspectFill
        imagetoUrl.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

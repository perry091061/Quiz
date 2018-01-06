//
//  TableViewCell.swift
//  Quiz
//
//  Created by Perry Davies on 25/09/2017.
//  Copyright © 2017 Perry Davies. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell
{
    
    @IBOutlet weak var fName:   UILabel!
    @IBOutlet weak var lName:   UILabel!
    @IBOutlet weak var img:     UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
        
        
    }
    func configPlayer(player: Player) -> TableViewCell?
    {
        fName.text = player.first_Name
        lName.text = player.last_Name
        img.image  = player.player_Image
        return self
    }
}

//
//  Player.swift
//  Quiz
//
//  Created by Perry Davies on 25/09/2017.
//  Copyright © 2017 Perry Davies. All rights reserved.
//

import Foundation
import Foundation
import UIKit

class Player
{
    var first_Name: String?
    var last_Name: String?
    var fppg: Double = 0.0
    var player_Url: String?
    var player_Image: UIImage?
    
    init(first_Name: String?,
         last_Name: String?,
         fppg: Double,
         player_Url: String?)
    {
        self.first_Name = first_Name
        self.last_Name = last_Name
        self.fppg = fppg
        self.player_Url = player_Url
        
        let imageQueue = DispatchQueue(label: "playerImage")
        imageQueue.async {
            self.player_Image = self.fetchImage()
            // Let the tableview no we have another pic to show
            let note = Notification.init(name: Notification.Name("Refresh"))
            NotificationCenter.default.post(note)
        }
    }
    
    // Get Players image
    func fetchImage() -> UIImage
    {
        if let url = URL(string: player_Url!)
        {
            if player_Image == nil
            {
                if let imgData = try? Data(contentsOf: url)
                {
                    return UIImage(data: imgData)!
                }
            }
        }
        return UIImage(named: "emptyImage")!
    }
}

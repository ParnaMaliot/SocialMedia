//
//  FollowingTableViewCell.swift
//  SocialMedia
//
//  Created by Igor Parnadziev on 29.12.20.
//

import UIKit

class FollowingTableViewCell: UITableViewCell {

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var userId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(userId: String) {
        DataStore.shared.getUser(uid: userId) { (user, error) in
            if let user = user {
                self.lblUserName.text = user.fullName
                if let imageUrl = user.imageUrl {
                    self.profileImage.kf.setImage(with: URL(string: imageUrl))
                } else {
                    self.profileImage.image = UIImage(named: "userPlaceholder")
                }
            }

        }
    }

}

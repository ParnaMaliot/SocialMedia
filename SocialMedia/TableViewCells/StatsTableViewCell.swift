

import UIKit

protocol StatsTableCellFollowersDelegate: class {
    func didClickOnFollowers()
}

protocol StatsTableCellFollowingDelegate: class {
    func didClickOnFollowing()
}


class StatsTableViewCell: UITableViewCell {
    
  
    

    @IBOutlet weak var lblMoments: UILabel!
    @IBOutlet weak var lblMomentsValue: UILabel!
    @IBOutlet weak var lblFollowersValue: UILabel!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblFollowingValue: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    
    var userId: String?
    var users = [User]()
    
    weak var delegateFollowers: StatsTableCellFollowersDelegate?
    weak var delegateFollowing: StatsTableCellFollowingDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblMoments.alpha = 0.5
        lblFollowers.alpha = 0.5
        lblFollowing.alpha = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCounts() {
        setFollowersCount()
        setFollowingCount()
    }
    
    
    
    private func setFollowersCount() {
        //database/users/myId or otherUserId/followers/
        guard let userId = userId else { return }
        DataStore.shared.getFollowCount(userId: userId, isFollowers: true) { (count, _) in
            self.lblFollowersValue.text = "\(count)"
        }
    }
    
    //database/users/myId or otherUserId/following/
    private func setFollowingCount() {
        guard let userId = userId else { return }

        DataStore.shared.getFollowCount(userId: userId, isFollowers: false) { (count, _) in
            self.lblFollowingValue.text = "\(count)"
        }
    }
    
    @IBAction func showFollowersButton(_ sender: UIButton) {
        delegateFollowers?.didClickOnFollowers()
    }
    
    @IBAction func showFollowingButton(_ sender: UIButton) {
        delegateFollowing?.didClickOnFollowing()
    }
    
}

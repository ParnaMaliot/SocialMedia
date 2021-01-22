//
//  FollowingViewController.swift
//  SocialMedia
//
//  Created by Igor Parnadziev on 29.12.20.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift
import FirebaseAuth


class FollowingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    

    var following = [Following]()
    var user: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()

    }

}

extension FollowingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func setupTableView() {
        tableView.register(UINib(nibName: "FollowingTableViewCell", bundle: nil), forCellReuseIdentifier: "FollowingTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        following.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowingTableViewCell", for: indexPath) as! FollowingTableViewCell
        
        let displayedCell = following[indexPath.row]
        if let userId = displayedCell.userId {
            cell.setData(userId: userId)
        }
        cell.selectionStyle = .none
        return cell
    }
}

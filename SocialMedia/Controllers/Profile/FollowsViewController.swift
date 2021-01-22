//
//  FollowsViewController.swift
//  SocialMedia
//
//  Created by Igor Parnadziev on 28.12.20.
//

import UIKit

class FollowsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var followers = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
}

extension FollowsViewController: UITableViewDelegate, UITableViewDataSource {
        
    func setupTableView() {
        tableView.register(UINib(nibName: "FollowsTableViewCell", bundle: nil), forCellReuseIdentifier: "FollowsTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowsTableViewCell") as! FollowsTableViewCell

        let displayedCell = followers[indexPath.row]
        cell.lblUserName.text = displayedCell.id
        return cell
    }
    
    
}

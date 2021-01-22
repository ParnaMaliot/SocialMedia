//
//  FollowManager.swift
//  SocialMedia
//
//  Created by Darko Spasovski on 28.12.20.
//

import Foundation

class FollowManager {
    static let shared = FollowManager()
    init(){}
    
    var following = [Following]()
    var followers = [Follower]()
    
    func getFollowing() {
        DataStore.shared.getFollowings { (followings, error) in
            if let followings = followings {
                self.following = followings
            }
        }
    }
    
    func getFollowers() {
        DataStore.shared.getFollowers { (followers, error) in
            if let followers = followers {
                self.followers = followers
            }
        }
    }
}

//
//  UITableViewCell.swift
//  SocialMedia
//
//  Created by Darko Spasovski on 11/25/20.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}

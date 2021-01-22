//
//  ProfileViewController.swift
//  SocialMedia
//
//  Created by Darko Spasovski on 11/16/20.
//

import UIKit
import Kingfisher
import CoreServices
import SwiftPhotoGallery

enum ProfileViewTableData {
    case basicInfo
    case aboutMe
    case stats
    case myMoments
    
    var cellIdentifier: String {
        switch self {
        case .basicInfo:
            return "basicCell"
        case .aboutMe:
            return "aboutMeCell"
        case .stats:
            return "statsCell"
        case .myMoments:
            return ""
        }
    }
    
    var cellHeight: CGFloat {
        switch self {
        case .basicInfo:
            return 95
        case .aboutMe:
            return 95
        case .stats:
            return 95
        case .myMoments:
            return 0
        }
    }
}

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let tableData: [ProfileViewTableData] = [.basicInfo, .aboutMe, .stats]
    
    private var pickedImage: UIImage?
    
    var user: User?
    var following = [Following]()
    
    private var galleryImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        title = "You"
        
        if user == nil {
            setupNewPostButton()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupNewPostButton() {
        let button = UIButton()
        button.setImage(UIImage(named: "newMoment"), for: .normal)
        button.setTitle(nil, for: .normal)
        button.addTarget(self, action: #selector(onEditProfile), for: .touchUpInside)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: button)]
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "BasicInfoTableViewCell", bundle: nil), forCellReuseIdentifier: ProfileViewTableData.basicInfo.cellIdentifier)    
        tableView.register(UINib(nibName: "AboutMeTableViewCell", bundle: nil), forCellReuseIdentifier: ProfileViewTableData.aboutMe.cellIdentifier)    
        tableView.register(UINib(nibName: "StatsTableViewCell", bundle: nil), forCellReuseIdentifier: ProfileViewTableData.stats.cellIdentifier)    
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor(hex: "#F1F1F1")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc func onEditProfile() {
        let storyBoard = UIStoryboard(name: "Auth", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "SetupProfileViewController") as! SetupProfileViewController
        controller.state = .editProfile
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func openEditImageSheet() {
        let actionSheet = UIAlertController(title: "Edit image", message: "Please pick an image", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.openImagePicker(sourceType: .camera)
        }
        let library = UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.openImagePicker(sourceType: .photoLibrary)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(library)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = false
        if sourceType == .camera {
            imagePicker.cameraDevice = .front
        }
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func uploadImage(image: UIImage) {
        guard var user = DataStore.shared.localUser, let userId = user.id else {
            return
        }
        
        DataStore.shared.uploadImage(image: image, itemId: userId) { (url, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let url = url {
                user.imageUrl = url.absoluteString
                DataStore.shared.setUserData(user: user) { (_, _) in }
            }
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage {
            self.pickedImage = image
            self.uploadImage(image: image)
            self.tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
        }
    }
}

extension ProfileViewController: BasicInfoCellDelegate {
    func didClickOnEditImage() {
        openEditImageSheet()
    }
    
    func didTapOnUserImage(user: User?, image: UIImage?) {
        if let image = image {
            let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)
            gallery.hidePageControl = true
            gallery.modalPresentationStyle = .fullScreen
            galleryImages.removeAll()
            galleryImages.append(image)
            present(gallery, animated: true, completion: nil)
        }
    }
}

extension ProfileViewController: SwiftPhotoGalleryDelegate, SwiftPhotoGalleryDataSource {
    func galleryDidTapToClose(gallery: SwiftPhotoGallery) {
        gallery.dismiss(animated: true, completion: nil)
    }
    
    func numberOfImagesInGallery(gallery: SwiftPhotoGallery) -> Int {
        return galleryImages.count
    }
    
    func imageInGallery(gallery: SwiftPhotoGallery, forIndex: Int) -> UIImage? {
        let image = galleryImages[forIndex]
        return image //galleryImages[forIndex]
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let localUser = DataStore.shared.localUser else {
            return UITableViewCell()
        }
        
        let data = tableData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: data.cellIdentifier)
        
//        if self.user != nil {
//            return getCellFor(data: data, user:self.user!, cell: cell)
//        } else {
//            return getCellFor(data: data, user:localUser, cell: cell)
//        }
        
        return getCellFor(data: data, user: (self.user != nil ? self.user! : localUser), cell: cell)
    }
    
    private func getCellFor(data: ProfileViewTableData, user: User, cell: UITableViewCell?) -> UITableViewCell {
        switch data {
        case .basicInfo:
            guard let basicCell = cell as? BasicInfoTableViewCell else {
                return UITableViewCell()
            }
            basicCell.profileImage.image = pickedImage
            basicCell.setData(user: user)
            basicCell.selectionStyle = .none
            basicCell.delegate = self
            return basicCell
        case .aboutMe:
            guard let aboutCell = cell as? AboutMeTableViewCell else {
                return UITableViewCell()
            }

            aboutCell.lblAboutMe.text = user.aboutMe
            aboutCell.selectionStyle = .none
            return aboutCell
            
        case .stats:
            guard let statsCell = cell as? StatsTableViewCell else {
                return UITableViewCell()
            }
            statsCell.lblMomentsValue.text = String(user.moments ?? 0)
            statsCell.selectionStyle = .none
            statsCell.userId = user.id
            statsCell.setCounts()
            statsCell.delegateFollowers = self
            statsCell.delegateFollowing = self
            return statsCell
        case .myMoments:
            return UITableViewCell()
        }
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = tableData[indexPath.row]
        return data.cellHeight
    }
}

extension ProfileViewController: StatsTableCellFollowersDelegate, StatsTableCellFollowingDelegate {
    
    func didClickOnFollowers() {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let controller = storyBoard.instantiateViewController(identifier: "FollowsViewController") as! FollowsViewController
        navigationController?.pushViewController(controller, animated: true)
    }
    

    
    func didClickOnFollowing() {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let controller = storyBoard.instantiateViewController(identifier: "FollowingViewController") as! FollowingViewController
        following = FollowManager.shared.following
        controller.following = following
        navigationController?.pushViewController(controller, animated: true)
    }
    

    
}

//
//  ProfileViewController.swift
//  GoGoGithub
//
//  Created by Matthew Weintrub on 11/16/15.
//  Copyright © 2015 Michael Babiy. All rights reserved.
//


import UIKit

//let kUserName = "name"
//let kUserLogin = "login"
//let kUserURL = "url"
//let kUserImageURL = "avatar_url"
//let kUserFollowers = "followers"
//let kUserFollowing = "following"
//let kUserEmail = "email"


class ProfileViewController: UIViewController {
    
    //MARK: properties
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userLoginLabel: UILabel!
    @IBOutlet weak var userFollowersLabel: UILabel!
    @IBOutlet weak var userFollowingLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    
    var user: User? {
        didSet {
            setUpView()
        }
    }
    
    //MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // MARK: Setup Functions
    
        func setUpView() {
            guard let user = self.user else { return }
//            self.userNameLabel.text = user.userName
//            self.userLoginLabel.text = user.userLogin
//            self.userFollowersLabel.text = "\(user.userFollowers)"
//            self.userFollowingLabel.text = "\(user.userFollowing)"
//            self.userEmailLabel.text = user.userEmail
            if let imageURl = NSURL(string: user.userImageURL) {
                let queue = NSOperationQueue()
                queue.addOperationWithBlock { () -> Void in
                    guard let imageData = NSData(contentsOfURL: imageURl) else { return }
                    let image = UIImage(data: imageData)
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.userImageView.image = image
                    })
                }
            }
        }

}


//
//  UserDetailViewController.swift
//  GoGoGithub
//
//  Created by Matthew Weintrub on 11/16/15.
//  Copyright © 2015 Michael Babiy. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    class func identifier() -> String {
        return "UserDetailViewController"
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userLoginLabel: UILabel!
    
    let customTransition = CustomModalTransition(duration: 6.0)
    
    var selectedUser: User? {
        didSet {
            print(selectedUser?.userLogin)
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadImage()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        setupViews()
        Animation.expandImage(userImageView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        Animation.animateImageRotatingZoomIn(userImageView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadImage () {
        guard let string = selectedUser?.userImageURL  else {return}
        guard let url = NSURL(string: (string)) else { return }
        let downloadQ = dispatch_queue_create("downloadQ", nil)
        dispatch_async(downloadQ, { () -> Void in
            let imageData = NSData(contentsOfURL: url)!
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                guard let image = UIImage(data: imageData) else { return }
                self.userImageView.image = image
            })
        })
    }
    
    func setupViews() {
        self.userLoginLabel.text = selectedUser?.userName
        self.userImageView.layer.cornerRadius =   userImageView.frame.size.width/2
    }
    
    // MARK: Transition
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.customTransition
    }
}

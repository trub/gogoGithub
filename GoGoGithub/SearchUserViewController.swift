//
//  SearchUserViewController.swift
//  GoGoGithub
//
//  Created by Michael Babiy on 11/13/15.
//  Copyright © 2015 Michael Babiy. All rights reserved.
//

import UIKit

class SearchUserViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UIViewControllerTransitioningDelegate {

    //MARK: properties
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let customTransition = CustomModalTransition(duration: 2.0)

    
    //MARK: constants
    let kUserName = "name"
    let kUserLogin = "login"
    let kUserURL = "url"
    let kUserImageURL = "avatar_url"
    let kUserFollowers = "followers"
    let kUserFollowing = "following"
    let kUserEmail = "email"

    
    var users = [User]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    class func identifier() -> String {
        return "SearchUserViewController"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.collectionViewLayout = CustomFlowLayout(columns: 3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func update(searchTerm: String) {
        print("hit update funk")
        do {
            let token = try MBGithubOAuth.shared.accessToken()
            
            guard let url = NSURL(string: "https://api.github.com/search/users?access_token=\(token)&q=\(searchTerm)") else { return }
            
            let request = NSMutableURLRequest(URL: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                
                if let error = error {
                    print(error)
                }
                guard let response = response as? NSHTTPURLResponse else { return }
                print("status code\(response.statusCode ) ")
                
                if let data = data {
                    
                    if let json = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [String : AnyObject] {
                        
                        if let items = json["items"] as? [[String : AnyObject]] {
                            
                            var users = [User]()
                            
                            for item in items {
                                
                                if let userName = item["login"] as? String,
                                userLogin = item[self.kUserLogin] as? String,
                                userURL = item[self.kUserURL] as? String,
                                    userImageURL = item[self.kUserImageURL] as? String{
                                
                                    let newuser =  User(userLogin: userLogin, userName: userName, userEmail: "", userURL: userURL, userImageURL: userImageURL, userFollowers: 0, userFollowing: 0)
                                    users.append(newuser)
                                    print("createing new user with name: \(newuser.userName)" )

                                }
                                
                            }
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                self.users = users
                            })
                            
                        }
                        
                    }
                    
                }
                
                }.resume()
        } catch {}
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("userCell", forIndexPath: indexPath) as! UserCollectionViewCell
        let user = self.users[indexPath.row]
        cell.user = user
        return cell
    }
    
    
    // MARK: UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let searchTerm = searchBar.text {
            if String.validateInput(searchTerm) {
                self.update(searchTerm)
            } else {
                let alert = UIAlertController(title: "No Bueno", message: "Your search for '\(searchBar.text!)' is no bueno.", preferredStyle: .Alert)
                let action = UIAlertAction(title: "lol", style: .Cancel, handler: nil)
                alert.addAction(action)
                presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        self.searchBar.resignFirstResponder()
        return true
    }
    
    // MARK: navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == UserDetailViewController.identifier() {
            if let cell = sender as? UICollectionViewCell, indexPath = collectionView.indexPathForCell(cell) {
                guard let userDetailViewController = segue.destinationViewController as? UserDetailViewController else {return}
                userDetailViewController.transitioningDelegate = self
                
                let user = users[indexPath.item]
                userDetailViewController.selectedUser = user
            }
        }
    }
    
    // MARK: Transition
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.customTransition
    }
    

    
}

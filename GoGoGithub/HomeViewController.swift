//
//  ViewController.swift
//  GoGoGithub
//
//  Created by Michael Babiy on 10/21/15.
//  Copyright © 2015 Michael Babiy. All rights reserved.
//

import UIKit



class HomeViewController: UIViewController, UITableViewDataSource {
    let kUserLogin = "login"
    let kUserURL = "url"
    let kUserImageURL = "avatar_url"
    let kUserFollowers = "followers"
    let kUserFollowing = "following"
    let kUserEmail = "email"

    
    @IBOutlet var tableView: UITableView!
    
    var repositories = [Repository]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var users = [User]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.update()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func update() {
        
        do {
            let token = try MBGithubOAuth.shared.accessToken()
            
            let url = NSURL(string: "https://api.github.com/user/repos?access_token=\(token)")!
            
            let request = NSMutableURLRequest(URL: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                
                if let error = error {
                    print(error)
                }
                
                if let data = data {
                    if let arraysOfRepoDictionaries = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [[String : AnyObject]] {
                        
                        var repositories = [Repository]()
                        
                        for eachRepository in arraysOfRepoDictionaries {
                            
                            
                            let name = eachRepository["name"] as? String
                            let id = eachRepository["id"] as? Int
                            let url = eachRepository["svn_url"] as? String
                            
                            
                            if let user = eachRepository["owner"] as? [String: AnyObject] {
                                if let userName = user[self.kUserLogin] as? String,
                                    userLogin = user[self.kUserLogin] as? String,
                                    userURL = user[self.kUserURL] as? String,
                                    userImageURL = user[self.kUserImageURL] as? String
                                {
                                    let newuser =  User(userLogin: userLogin, userName: userName, userEmail: "", userURL: userURL, userImageURL: userImageURL, userFollowers: 0, userFollowing: 0)
                                    self.users.append(newuser)
                                }
                                
                            }
                            
                            if let name = name, id = id, url = url  {
                                let repo = Repository(name: name, id: id, url: url)
                                repositories.append(repo)
                            }                        }
                        
                        // This is because NSURLSession comes back on a background q.
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.repositories = repositories
                        })
                    }
                }
            }.resume()
        } catch {}
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let repository = self.repositories[indexPath.row]
        
        cell.textLabel?.text = repository.name
        
        return cell
        
    }
    
    //MARK: navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "ProfileSegue" {
            if let profileVC = segue.destinationViewController as? ProfileViewController {
                var newUser = self.users[0]
                profileVC.user = newUser
            }

        }
    }

    
}


//
//  SearchRepoViewController.swift
//  GoGoGithub
//
//  Created by Michael Babiy on 11/13/15.
//  Copyright © 2015 Michael Babiy. All rights reserved.
//

import UIKit
import SafariServices

class SearchRepoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var repositories = [Repository]() {
        didSet {
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
            
        }
    }
    
    class func identifier() -> String {
        return "SearchRepoViewController"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func update(searchTerm: String) {
        
        do {
            let token = try MBGithubOAuth.shared.accessToken()
            
            let url = NSURL(string: "https://api.github.com/search/repositories?access_token=\(token)&q=\(searchTerm)")!
            
            let request = NSMutableURLRequest(URL: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                
                if let error = error {
                    print(error)
                }
                
                if let data = data {
                    if let dictionaryOfRepositories = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [String : AnyObject] {
                        
                        if let items = dictionaryOfRepositories["items"] as? [[String : AnyObject]] {
                            
                         
                            var repositories = [Repository]()
                            
                            for eachRepository in items {
                                let name = eachRepository["name"] as? String
                                let id = eachRepository["id"] as? Int
                                let repositoryUrl = eachRepository["svn_url"] as? String
                                
                                if let name = name, id = id, repositoryUrl = repositoryUrl {
                                    let repo = Repository(name: name, id: id, url: repositoryUrl)
                                    repositories.append(repo)
                                }
                            }
                            
                            // This is because NSURLSession comes back on a background q.
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                self.repositories = repositories
                            })
                        }
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
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath)
        let repository = self.repositories[indexPath.row]
        cell.textLabel?.text = repository.name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedRepositoryUrl = repositories[indexPath.row].url
        print("The selected repo url for safari is: \(selectedRepositoryUrl)")
        
        let safariViewController = SFSafariViewController(URL: NSURL(string: selectedRepositoryUrl)!, entersReaderIfAvailable: true)
        safariViewController.delegate = self
        self.presentViewController(safariViewController, animated: true, completion: nil)
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

    
    // MARK: SFSafariViewControllerDelegate
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

}

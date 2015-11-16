//
//  SearchRepoViewController.swift
//  GoGoGithub
//
//  Created by Michael Babiy on 11/13/15.
//  Copyright © 2015 Michael Babiy. All rights reserved.
//

import UIKit

class SearchRepoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
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
                                
                                
                                if let name = name, id = id {
                                    let repo = Repository(name: name, id: id)
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
    
    // MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else {return}
        self.update(searchTerm)
    }

}

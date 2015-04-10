//
//  PhotosViewController.swift
//  instagram
//
//  Created by Bryan McLellan on 4/9/15.
//  Copyright (c) 2015 Bryan McLellan. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let refreshControl = UIRefreshControl()
    
    
    
    var photos = [NSDictionary]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: .ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        var clientId = "10dd953d978e4c49b9f15437ccf2ba81"
        var url = NSURL(string: "https://api.instagram.com/v1/media/popular?client_id=\(clientId)")!
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            self.photos = responseDictionary["data"] as Array<NSDictionary>
            self.tableView.reloadData()
            
            self.tableView.rowHeight = 320;
            
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            println("response: \(self.photos)")
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func onRefresh(){
        
        var clientId = "10dd953d978e4c49b9f15437ccf2ba81"
        var url = NSURL(string: "https://api.instagram.com/v1/media/popular?client_id=\(clientId)")!
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            self.photos = responseDictionary["data"] as Array<NSDictionary>
            self.tableView.reloadData()
            
            println("response: \(self.photos)")
            self.refreshControl.endRefreshing()
        }

        
        
        
    }
    
    
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("photoCell", forIndexPath: indexPath) as photoCell
        var photo = photos[indexPath.section]
        var url = photo.valueForKeyPath("images.standard_resolution.url") as? String
        cell.photoView.setImageWithURL(NSURL(string:url!)!)
        
        return cell
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return photos.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60;
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 60))
        headerView.backgroundColor = UIColor(red: 192/255.0, green: 192/255.0, blue: 192/255.0, alpha: 0.4)
        
        var profileView = UIImageView(frame: CGRect(x: 5, y: 15, width: 30, height: 30))
        var nameView = UILabel(frame: CGRect(x: 50, y: 5, width: 270, height: 50))
        var photo = photos[section]
        nameView.text = photo.valueForKeyPath("user.username") as? String
        nameView.textColor = UIColor(red: 76.0/255.0, green: 102.0/255.0, blue: 164.0/255.0, alpha: 0.8)
        nameView.font = UIFont.boldSystemFontOfSize(20)
        var url = photo.valueForKeyPath("user.profile_picture") as? String
        profileView.setImageWithURL(NSURL(string:url!)!)
        headerView.addSubview(nameView)
        headerView.addSubview(profileView)
        return headerView
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var vc = segue.destinationViewController as PhotosDetailsViewController
        var indexPath = tableView.indexPathForCell(sender as photoCell)!
        
        vc.photo = photos[indexPath.row]
    }


}

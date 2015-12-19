//
//  RootViewController.swift
//  iTunesAPI
//
//  Created by Kodama Takahiro on 2015/12/15.
//  Copyright © 2015年 Kiyoshi. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var trackNames = NSMutableArray()
    var previewUrls = NSMutableArray()
    var isLoadNow = false

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        let searchWord: String? = searchBar.text?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())

        if let searchWord = searchWord {
            self.isLoadNow = true
            let urlString:String = "http://itunes.apple.com/search?term=\(searchWord)&country=JP&lang=ja_jp&media=music&entity=song&attribute=artistTerm&limit=30"
            let url:NSURL! = NSURL(string:urlString)

            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {data, response, error in
                let json = JSON(data: data!)
                for var i = 0; i < json["results"].length; i++ {
                    self.trackNames[i] = "\(json["results"][i]["trackName"])"
                    self.previewUrls[i] = "\(json["results"][i]["previewUrl"])"
                }
                self.isLoadNow = false
            })
            task.resume()
            while isLoadNow {
                usleep(5)
            }
        }

        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trackNames.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = self.trackNames[indexPath.row] as? String
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? DetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.previewUrl = previewUrls[indexPath.row] as? String
            }
        }
    }
}

//
//  ViewController.swift
//  verbinski
//
//  Created by sanjaypojo on 12/08/14.
//  Copyright (c) 2014 sanjaypojo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
                            
    @IBOutlet var movieSearch: UITextField!
    @IBOutlet var movieTitle: UITextView!
    @IBOutlet var movieTable: UITableView!
    var movieInfo = ["Hello"]
    var apiKey = "2bbea3556aa78a3d08cc941d53a2f83e"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieSearch.delegate = self
        movieTable.dataSource = self
        movieTable.delegate = self
        movieTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return movieInfo.count
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell: UITableViewCell = movieTable.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        cell.textLabel.text = movieInfo[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView!, didDeselectRowAtIndexPath indexPath: NSIndexPath!) {
        println("Cell selected")
    }

    
    @IBAction func movieSearchGo(sender: AnyObject) {
        println("Started")
        var currentMovieInfo:[String] = []
        var infoParams : NSArray = ["Title", "Writer", "Year", "Director", "imdbRating", "Runtime", "Genre", "Actors"]
        var urlString = "http://www.omdbapi.com/?t=" + movieSearch.text
        urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)
        println(urlString)
        let url = NSURL.URLWithString(urlString)
        let request = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) in
            var movieDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as Dictionary<String, String>
            let titleFetched:String! = movieDict["Title"]
            for (key, value) in movieDict {
                if infoParams.containsObject(key) == true {
                    currentMovieInfo.append("\(key) : \(value)")
                }
            }
            println("Ended")
            dispatch_async(dispatch_get_main_queue(), {
                self.movieTitle.text = "\(titleFetched)"
                self.movieInfo = currentMovieInfo
                self.movieTable.reloadData()
            });
        });
        task.resume()
    }

}


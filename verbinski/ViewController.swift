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
    @IBOutlet var movieImage: UIImageView!
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

    
    @IBAction func movieSearchGo(sender: AnyObject) {
        println("Started - movie fetch")
        var currentMovieInfo:[String] = []
        var infoParams : NSArray = ["Title", "Writer", "Year", "Director", "imdbRating", "Runtime", "Genre", "Actors"]
        
        var urlString = ("http://www.omdbapi.com/?t=" + movieSearch.text).stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)
        let request = NSURLRequest(URL: NSURL(string: urlString))
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler:
        { (data, response, error) in
            
            var movieDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as Dictionary<String, String>
            if movieDict["Title"] == nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.movieTitle.text = "Not Found"
                    self.movieInfo = ["Woopsie, couldn't find the movie!"]
                    self.movieTable.reloadData()
                    self.movieImage.image = nil
                });
                println("Failed - movie fetch")
                return
            }

            for (key, value) in movieDict {
                if infoParams.containsObject(key) == true {
                    currentMovieInfo.append("\(key) : \(value)")
                }
            }
            let titleFetched:String! = movieDict["Title"]
            let imgFetched:String! = movieDict["Poster"]
            let imgData: NSData! = NSData(contentsOfURL: NSURL(string: imgFetched))
            println("Completed - movie fetch")
            
            dispatch_async(dispatch_get_main_queue(), {
                self.movieTitle.text = "\(titleFetched)"
                self.movieInfo = currentMovieInfo
                self.movieTable.reloadData()
                self.movieImage.image = UIImage(data: imgData)
            });
        });
        
        task.resume()
    }

}


//
//  ViewController.swift
//  verbinski
//
//  Created by sanjaypojo on 12/08/14.
//  Copyright (c) 2014 sanjaypojo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
                            
    @IBOutlet var movieSearch: UITextField!
    @IBOutlet var movieTitle: UITextView!
    @IBOutlet var movieImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        movieSearch.text = "The Big Lebowski"
        self.movieSearchGo(movieSearch)
        var moviePic : UIImage = UIImage(named: "sanjay.jpg")
        movieImage.image = moviePic
        movieSearch.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func movieSearchGo(sender: AnyObject) {
        println("Started")
        var urlString = "http://www.omdbapi.com/?t=" + movieSearch.text
        urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)
        println(urlString)
        let url = NSURL.URLWithString(urlString)
        let request = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) in
            var movieDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as Dictionary<String, String>
            let titleFetched :String! = movieDict["Year"]
            println("\(titleFetched)")
            println("Ended")
            dispatch_async(dispatch_get_main_queue(), {
                self.movieTitle.text = "\(titleFetched)"
            });
        });
        task.resume()
    }

}


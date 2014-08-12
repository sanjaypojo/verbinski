//
//  ViewController.swift
//  verbinski
//
//  Created by sanjaypojo on 12/08/14.
//  Copyright (c) 2014 sanjaypojo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    @IBOutlet var movieSearch: UITextField!
    @IBOutlet var movieTitle: UITextView!
    @IBOutlet var movieImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        movieTitle.text = "The Big Lebowski"
        var moviePic : UIImage = UIImage(named: "sanjay.jpg")
        movieImage.image = moviePic
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


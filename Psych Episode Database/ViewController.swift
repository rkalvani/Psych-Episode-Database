//
//  ViewController.swift
//  Psych Episode Database
//
//  Created by rkalvani on 10/24/16.
//  Copyright © 2016 rkalvani. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var myTableView: UITableView!
    
    //initializing empty array of dictionaries
    var episodes = [[String: String]]()
    //initializing empty array.
    var epNameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let URLString = "http://api.tvmaze.com/shows/517/episodes"
        //if statement check to see if URL is valid
        if let url = NSURL(string: URLString)
        {
            //returns data from object URL. Try checks for URL connections
            if let myData = try? NSData(contentsOfURL: url, options: []) {
                //if data object was created successfully, we create  swift json structure
                let json = JSON(data: myData)
                print ("wOrkin!")
                parse(json)
            }
            }
    
    }
        //reads the results array from api
        func parse(json: JSON) {
            for result in json[].arrayValue {
                //grabbing values from keys
                let name = result["name"].stringValue
                let season = result["season"].stringValue
                let number = result["number"].stringValue
                let summary = result["summary"].stringValue
                let picture = result["image"]["original"].stringValue
                
                //creates a dictionary with keys and values
                let object = ["name" : name, "season": season, "number": number, "summary" : summary, "image" : picture]
                // places it in array
                episodes.append(object)
                // places names in array
                epNameArray.append(name)
                
           }
            myTableView.reloadData()
        }
    
    func randomEpisode()
    {
        // creates random number from the number of episode names there are.
        let randomIndex = Int(arc4random_uniform(UInt32(epNameArray.count)))
        
       print(epNameArray[randomIndex])
        // creates alert that shows episode name.
        let myAlert = UIAlertController(title: epNameArray[randomIndex], message: nil, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "You know that's right!", style: UIAlertActionStyle.Cancel, handler: nil)
        myAlert.addAction(cancelAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
    //sets the title and info text in the cell
        let episode = episodes[indexPath.row]
        cell.textLabel?.text = episode["name"]
        cell.detailTextLabel?.text = "Season: \(episode["season"]!)  Episode:\(episode["number"]!)"
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count //makes cells for the number of episodes
    }

    
    @IBAction func RandomEpisodeButtonPressed(sender: UIBarButtonItem)
    {
        randomEpisode()
    }
    
    // segue of image and summary to detail view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let indexPath = myTableView.indexPathForSelectedRow
        {
            let episode = episodes[indexPath.row]
            let nextController = segue.destinationViewController as! detailViewController
            
            nextController.detailImage = episode["image"]!
            nextController.detailSummary = episode["summary"]!
        }

    }

}


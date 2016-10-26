//
//  detailViewController.swift
//  Psych Episode Database
//
//  Created by rkalvani on 10/25/16.
//  Copyright © 2016 rkalvani. All rights reserved.
//

import UIKit

class detailViewController: UIViewController
{

    @IBOutlet weak var episodeImage: UIImageView!

    var detailImage : String!
    
    enum ErrorHandling:ErrorType
    {
        case NetworkError
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

       load_image(detailImage)
        
    }

    func load_image(urlString:String)
    {
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil)
            {
                func display_image()
                {
                    self.episodeImage.image = UIImage(data: data!)
                }
                
                dispatch_async(dispatch_get_main_queue(), display_image)
            }
            
        }
        
        task.resume()
    }

}

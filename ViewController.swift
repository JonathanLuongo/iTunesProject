//
//  ViewController.swift
//  iTunesProject
//
//  Created by Luongo, Jonathan C. on 8/19/16.
//  Copyright © 2016 Luongo, Jonathan C. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var apps: [appStore] = []
    var limit: Int = 2
    
    @IBOutlet var stepper: UIStepper!
    @IBOutlet var label: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var statusbar: UIActivityIndicatorView!


    
    
    

    @IBAction func stepChange(sender: UIStepper) {
        limit = Int(stepper.value)
        label.text = String(limit)
    }
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 10.0
        tableView.rowHeight = UITableViewAutomaticDimension
        stepper.value = Double(limit)
        label.text = String(limit)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // grouped vertical sections of the tableview
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // total row count goes here
        return apps.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // at init/appear ... this runs for each visible cell that needs to render
        let appcell = tableView.dequeueReusableCellWithIdentifier("customcell", forIndexPath: indexPath) as! Custom_TableViewCell
        
        let idx: Int = indexPath.row
        let appname = apps[idx].title // TODO: check for null
        print(appname)
        
        appcell.appTitle?.text = apps[idx].title
       let url: String = (NSURL(string: apps[idx].imageUrl)?.absoluteString)!
        
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), { // () -> Void in
                let image = UIImage(data: data!)
                appcell.appImageView?.image = image
                //        appcell.layoutSubviews() 
            })
        }).resume()
        
        return appcell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "iTunes Top Apps"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detail = self.storyboard!.instantiateViewControllerWithIdentifier("CustomViewController") as! DetailViewController
        
        self.navigationController?.pushViewController(detail, animated: true)
        
        detail.getData = { [ weak self ] in
            return self!.apps[ indexPath.row ]
        }
    }

    

@IBAction func getDataButton(sender: UIButton) {
    apps = []
    
    // http://rss.itunes.apple.com/us/?urlDesc=%2Fgenerator
    let url = NSURL(string: "https://itunes.apple.com/us/rss/topgrossingapplications/limit=\(limit)/json")!
    
    let session = NSURLSession.sharedSession()
    
  //  activityIndicator.startAnimating()
    let task = session.dataTaskWithURL(url) { (data, response, error) in
        if let response = response {
            print("Data encoding: \(response.textEncodingName)")
        }
        
        if let error = error {
            NSLog("Got an error!: \(error.localizedDescription)")
    //        self.activityIndicator.stopAnimating()
            return
        }
        
        if let data = data {
            NSLog("Got \(data.length) bytes.")
            let str = String(data: data, encoding: NSISOLatin1StringEncoding)
            
            print("*** Here are the string contents:")
            print(str)
            print("*** ***")
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Status code = \(statusCode)")
                print("Everyone is fine, file downloaded successfully.")
                
                let possibleJson = self.parseJson(data)
                if let json = possibleJson {
                    print(json["feed"])
                    print(json["feed"]!.dynamicType)
                    
                    guard let dict = json["feed"] as? NSDictionary else { return }
                    guard let entries = dict["entry"] as? NSArray else { return }
                    
                    print(dict["entry"])
                    
                    for entry in entries {
                        guard let entryDict = entry as? NSDictionary else { continue }
                        guard let titleDict = entryDict["title"] as? NSDictionary else { continue }
                        guard let label = titleDict["label"] as? String else { continue }
                        
                        print("*** label = \(label ?? " ")")
                        
                        guard let summaryDict = entryDict["summary"] as? NSDictionary else { continue }
                        guard let summary = summaryDict["label"] as? String else { continue }
                        
                        guard let images = entryDict["im:image"] as? NSArray else { continue }
                        let image = images[0] as! NSDictionary
                        let imageUrl = image["label"]! as! String
                        print("image url = \(imageUrl)")
                        
                        self.apps.append(appStore(title: label, imageUrl: imageUrl, summary: summary))
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                      print(self.apps[0].title)
                        self.tableView.reloadData()
                  //      self.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
    task.resume()
}





func parseJson(data: NSData) -> [String: AnyObject]? {
    let options = NSJSONReadingOptions()
    do {
        let json = try NSJSONSerialization.JSONObjectWithData(data, options: options) as? [String: AnyObject]
        if let json = json {
            print("*** Here is the JSON")
            print(json)
            print("*** ***")
        }
        return json
    }
    catch (let parsingError) {
        print(parsingError)
    }
    return nil
}

}




//
//  CustomViewController.swift
//  iTunesProject
//
//  Created by Luongo, Jonathan C. on 8/19/16.
//  Copyright © 2016 Luongo, Jonathan C. All rights reserved.
//



import UIKit

class DetailViewController: UIViewController {
    var getData: (() -> (appStore))?
    var itunesApp: appStore? = nil
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let closure = self.getData {
            itunesApp = closure()
            self.titleLabel.text = itunesApp!.title
            self.summaryLabel.text = itunesApp!.summary
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}
}
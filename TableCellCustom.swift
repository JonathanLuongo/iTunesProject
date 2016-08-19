//
//  TableCellCustom.swift
//  iTunesProject
//
//  Created by Luongo, Jonathan C. on 8/19/16.
//  Copyright © 2016 Luongo, Jonathan C. All rights reserved.
//


import UIKit


class Custom_TableViewCell: UITableViewCell {
    
    @IBOutlet var appImageView: UIImageView!
    @IBOutlet var appTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
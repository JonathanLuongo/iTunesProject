//
//  appStore.swift
//  iTunesProject
//
//  Created by Luongo, Jonathan C. on 8/19/16.
//  Copyright © 2016 Luongo, Jonathan C. All rights reserved.
//

import Foundation

class appStore {
    

var title: String = ""
var imageUrl: String = ""
var summary: String = ""

init(title: String, imageUrl: String, summary: String) {
    self.title = title
    self.imageUrl = imageUrl
    self.summary = summary
}
}
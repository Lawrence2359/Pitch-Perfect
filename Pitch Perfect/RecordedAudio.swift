//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Lawrence Tan on 9/18/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init (withFilePath filePathUrl: NSURL, andTitle title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}


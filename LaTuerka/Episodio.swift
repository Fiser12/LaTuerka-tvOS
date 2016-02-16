//
//  Episodio.swift
//  LaTuerka
//
//  Created by Fiser on 12/2/16.
//  Copyright © 2016 Fiser. All rights reserved.
//

import Foundation
import UIKit
class Episodio {
    var url: String = ""
    var image: UIImage
    var data: NSDate
    var titulo: String
    init(URL url:String, Imagen image: UIImage, Fecha data: NSDate, Titulo titulo: String)
    {
        self.url = url
        self.image = image
        self.data = data
        self.titulo = titulo
    }
}
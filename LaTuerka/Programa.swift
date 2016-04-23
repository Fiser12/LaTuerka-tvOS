//
//  Programa.swift
//  LaTuerka
//
//  Created by Fiser on 10/2/16.
//  Copyright © 2016 Fiser. All rights reserved.
//

import Foundation
import UIKit

class Programa{
    var url: String = ""
    var image: UIImage
    var episodios: [Episodio]
    var titulo: String
    init()
    {
        self.episodios = []
        self.titulo = ""
        self.url = ""
        self.image = UIImage()
    }
    init (Imagen image: UIImage, URL url: String, Titulo titulo: String){
        self.image = image
        self.url = url
        self.episodios = []
        self.titulo = titulo
    }
}
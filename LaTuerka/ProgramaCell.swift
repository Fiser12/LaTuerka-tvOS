//
//  CollectionViewCell.swift
//  LaTuerka
//
//  Created by Fiser on 10/2/16.
//  Copyright © 2016 Fiser. All rights reserved.
//

import UIKit

class ProgramaCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    func configurar(let programa:Programa)
    {
        self.img.image = programa.image
    }
}

//
//  CollectionViewCell.swift
//  LaTuerka
//
//  Created by Fiser on 10/2/16.
/*
 This file is part of Foobar.
 
 Foobar is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 Foobar is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
 */


import UIKit

class ProgramaCell: UICollectionViewCell {
    
    @IBOutlet weak var barra: UIImageView!
    @IBOutlet weak var img: UIImageView!
    var url: String = ""
    var programa: Programa!
    @IBOutlet weak var cellTitle: UILabel!
    func configurar(_ programa:Programa)
    {
        self.programa = programa
        self.img.image = programa.image
        self.url = programa.url
        self.cellTitle.font = UIFont(name:"HelveticaNeue-Bold",size: 24)
        self.cellTitle.text = programa.titulo
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // These properties are also exposed in Interface Builder.
        img.adjustsImageWhenAncestorFocused = true
        img.clipsToBounds = false
        cellTitle.adjustsFontSizeToFitWidth = true
    }
    
    // MARK: UICollectionReusableView
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

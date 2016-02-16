//
//  CollectionViewCell.swift
//  LaTuerka
//
//  Created by Fiser on 10/2/16.
//  Copyright © 2016 Fiser. All rights reserved.
//

import UIKit

class ProgramaCell: UICollectionViewCell {
    
    @IBOutlet weak var barra: UIImageView!
    @IBOutlet weak var img: UIImageView!
    var url: String = ""
    var programa: Programa!
    @IBOutlet weak var cellTitle: UILabel!
    func configurar(programa:Programa)
    {
        self.programa = programa
        self.img.image = programa.image
        self.url = programa.url
        self.barra.image = UIImage(named: "barra")
        self.cellTitle.text = programa.titulo
        self.cellTitle.font = UIFont(name:"HelveticaNeue-Bold",size: 24)

    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // These properties are also exposed in Interface Builder.
        img.adjustsImageWhenAncestorFocused = true
        img.clipsToBounds = false
        barra.adjustsImageWhenAncestorFocused = true
        barra.clipsToBounds = false
        
    }
    
    // MARK: UICollectionReusableView
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

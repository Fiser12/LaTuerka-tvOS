//
//  CollectionViewCell.swift
//  LaTuerka
//
//  Created by Fiser on 10/2/16.
//  Copyright © 2016 Fiser. All rights reserved.
//

import UIKit

class EpisodioCell: UICollectionViewCell {
    
    @IBOutlet weak var barra: UIImageView!
    @IBOutlet weak var img: UIImageView!
    var url: String = ""
    var episodio:Episodio!
    @IBOutlet weak var cellTitle: UILabel!
    func configurar(let episodio:Episodio)
    {
        self.episodio = episodio
        self.img.image = episodio.image
        self.url = episodio.url
        self.cellTitle.text = episodio.titulo
        self.cellTitle.font = UIFont(name:"HelveticaNeue-Bold",size: 24)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // These properties are also exposed in Interface Builder.
        img.adjustsImageWhenAncestorFocused = true
        img.clipsToBounds = false
    }
    
    // MARK: UICollectionReusableView
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

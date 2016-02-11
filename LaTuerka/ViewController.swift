//
//  ViewController.swift
//  LaTuerka
//
//  Created by Fiser on 10/2/16.
//  Copyright © 2016 Fiser. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    //Los programas que vamos a tener, los precargamos aquí para que consuma menos
    let data:[Programa] = [Programa(Imagen: UIImage(named: "laTuerkaActualidad")!, URL: ""),
        Programa(Imagen: UIImage(named: "elTornillo")!, URL: ""),
        Programa(Imagen: UIImage(named: "laKlau")!, URL: ""),
        Programa(Imagen: UIImage(named: "laTuerkaNews")!, URL: ""),
        Programa(Imagen: UIImage(named: "enClaveTuerka")!, URL: ""),
        Programa(Imagen: UIImage(named: "otraVueltaDeTuerka")!, URL: "")]
    let defaultSize = CGSizeMake(450,250)
    let focusSize = CGSizeMake(495, 275)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /**
    Establece una única sección para la colección
    */
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    /**
    Decimos el número de elementos que va a tener
    */
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    /**
     Este método permite configurar cada celda con los datos necesarios
    */
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let celda: ProgramaCell = collectionView.dequeueReusableCellWithReuseIdentifier("ProgramaCell", forIndexPath: indexPath) as? ProgramaCell
        {
            let programa = data[indexPath.row]
            celda.configurar(programa)
            return celda;
        }
        else
        {
            return ProgramaCell()
        }
    }
    /**
     Este método permite poner elementos en la cabecera (Header)
    */
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let commentView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath) as! ViewHeaderPrograms
        
        commentView.logo = UIImageView(image: UIImage(named: "logo"))
        commentView.barra = UIImageView( image: UIImage(named: "barra"))
        return commentView
    }
    /**
     Este método se encarga de establecer el foco
    */
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        if let prev = context.previouslyFocusedView as? ProgramaCell{
            UIView.animateWithDuration(0.1, animations: {() -> Void in
                prev.img.frame.size = self.defaultSize
            })
        }
        if let next = context.nextFocusedView as? ProgramaCell{
            UIView.animateWithDuration(0.1, animations: {() -> Void in
                next.img.frame.size = self.focusSize
            })
        }
    }
}


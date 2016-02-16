//
//  ViewController.swift
//  LaTuerka
//
//  Created by Fiser on 10/2/16.
//  Copyright © 2016 Fiser. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIGestureRecognizerDelegate {
    //Los programvarque vamos a tener, los precargamos aquí para que consuma menos
    let data:[Programa] = [
        Programa(Imagen: UIImage(named: "laTuerkaActualidad")!, URL: "http://especiales.publico.es/publico-tv/la-tuerka/tuerka-actualidad", Titulo: "LA TUERKA ACTUALIDAD"),
        Programa(Imagen: UIImage(named: "elTornillo")!, URL: "http://especiales.publico.es/publico-tv/la-tuerka/el-tornillo", Titulo: "EL TORNILLO"),
        Programa(Imagen: UIImage(named: "laKlau")!, URL: "http://especiales.publico.es/publico-tv/la-tuerka/la-klau", Titulo: "LA KLAU"),
        Programa(Imagen: UIImage(named: "laTuerkaNews")!, URL: "http://especiales.publico.es/publico-tv/la-tuerka/tuerka-news", Titulo: "LA TUERKA NEWS"),
        Programa(Imagen: UIImage(named: "enClaveTuerka")!, URL: "http://especiales.publico.es/publico-tv/la-tuerka/en-clave-tuerka", Titulo: "EN CLAVE TUERKA"),
        Programa(Imagen: UIImage(named: "otraVueltaDeTuerka")!, URL: "http://especiales.publico.es/publico-tv/la-tuerka/otra-vuelta-de-tuerka", Titulo: "OTRA VUELTA DE TUERKA")]
    let defaultSize = CGSizeMake(450,250)
    let focusSize = CGSizeMake(495, 275)
    var crawler:Crawler!
    override func viewDidLoad() {
        super.viewDidLoad()
        crawler = Crawler(Programas: data)
        self.collectionView?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func gestureRecognizer(_: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
            return true
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinoController: ProgramaSelector = segue.destinationViewController as! ProgramaSelector
        let cell:ProgramaCell = sender as! ProgramaCell
        destinoController.data = cell.programa
    }
}


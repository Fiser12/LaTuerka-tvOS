//
//  ViewController.swift
//  LaTuerka
//
//  Created by Fiser on 10/2/16.
//  Copyright © 2016 Fiser. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIGestureRecognizerDelegate, Observer {
    override func viewDidLoad() {
        super.viewDidLoad()
        Crawler.sharedInstance.addObserver(self)
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
        return Crawler.sharedInstance.programas.count
    }
    /**
     Este método permite configurar cada celda con los datos necesarios
    */
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let celda: ProgramaCell = collectionView.dequeueReusableCellWithReuseIdentifier("ProgramaCell", forIndexPath: indexPath) as? ProgramaCell
        {
            let programa = Crawler.sharedInstance.programas[indexPath.row]
            celda.configurar(programa)
            return celda;
        }
        else
        {
            return ProgramaCell()
        }
    }
    func observerID() -> String
    {
        return "Central"
    }
    func invocar()
    {
        for index in 0 ..< Crawler.sharedInstance.programas.count {
            let celda: ProgramaCell = (self.collectionView?.visibleCells()[index] as? ProgramaCell)!
            if let imagen:UIImage = Crawler.sharedInstance.programas[index].episodios.first?.image{
                celda.programa.image = imagen
                UIView.transitionWithView(self.view!, duration: 0.5, options: .TransitionCrossDissolve, animations: {() -> Void in
                    celda.img.image = imagen
                    }, completion: { _ in })
            }
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
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({
            context.previouslyFocusedView?.transform = CGAffineTransformIdentity
            context.previouslyFocusedView?.layer.shadowColor = UIColor.clearColor().CGColor
            context.nextFocusedView?.transform = CGAffineTransformMakeScale(1.10, 1.10)
            context.nextFocusedView?.layer.shadowColor = UIColor.blackColor().CGColor
            context.nextFocusedView?.layer.shadowRadius = 8.0
            context.nextFocusedView?.layer.shadowOffset = CGSizeMake(0,2)
            context.nextFocusedView?.layer.shadowOpacity = 1.0
            }, completion: nil)
    }
    
}


//
//  ProgramaSelector.swift
//  LaTuerka
//
//  Created by Fiser on 14/2/16.
//  Copyright © 2016 Fiser. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer

private let reuseIdentifier = "Cell"
class ProgramaSelector: UICollectionViewController {
    var data:Programa = Programa()
    let defaultSize = CGSizeMake(450,250)
    let focusSize = CGSizeMake(495, 275)
    
    var avPlayer:AVPlayer = AVPlayer()
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return self.data.episodios.count
    }
    /**
     Este método permite configurar cada celda con los datos necesarios
     */
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let celda: EpisodioCell = collectionView.dequeueReusableCellWithReuseIdentifier("EpisodioCell", forIndexPath: indexPath) as? EpisodioCell
        {
            let episodio = data.episodios[indexPath.row]
            celda.configurar(episodio)
            return celda;
        }
        else
        {
            return EpisodioCell(coder: NSCoder())!
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
        let destinoController: AVPlayerViewController = segue.destinationViewController as! AVPlayerViewController
        let cell:EpisodioCell = sender as! EpisodioCell
        let videoURL:NSURL = NSURL(string: cell.url)!
        self.avPlayer = AVPlayer(URL: videoURL)
        destinoController.player = self.avPlayer
        destinoController.player?.play()
    }
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        if let indexPath = collectionView.indexPathsForSelectedItems()?.first {
            collectionView.deselectItemAtIndexPath(indexPath, animated: true)
            return false
        }
        else {
            return true
        }
    }
    override func collectionView(collectionView: UICollectionView, shouldUpdateFocusInContext context: UICollectionViewFocusUpdateContext) -> Bool {
        guard let indexPaths = collectionView.indexPathsForSelectedItems() else { return true }
        return indexPaths.isEmpty
    }
    /**
     Este método se encarga de establecer el foco
     */
   
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

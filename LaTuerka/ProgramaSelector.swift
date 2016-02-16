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
        super.didUpdateFocusInContext(context, withAnimationCoordinator: coordinator)
        
        if let prev = context.previouslyFocusedView as? EpisodioCell{
            UIView.animateWithDuration(0.1, animations: {() -> Void in
                prev.img.frame.size = self.defaultSize
                prev.barra.frame.origin.y -= 25
                prev.barra.frame.size = CGSizeMake(450, 65)
                prev.cellTitle.frame.origin.y -= 25
                prev.cellTitle.frame.origin.x -= 15
                prev.cellTitle.transform = CGAffineTransformMakeScale(0.9,0.9);
                
            })
        }
        if let next = context.nextFocusedView as? EpisodioCell{
            UIView.animateWithDuration(0.1, animations: {() -> Void in
                next.img.frame.size = self.focusSize
                next.barra.frame.origin.y += 25
                next.barra.frame.size = CGSizeMake(495, 71)
                next.cellTitle.frame.origin.y += 25
                next.cellTitle.frame.origin.x += 15
                next.cellTitle.transform = CGAffineTransformMakeScale(1.1,1.1)
                
            })
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? EpisodioCell else { fatalError("Expected to display a `DataItemCollectionViewCell`.") }
        composeCell(cell)
    }

    func composeCell(cell: EpisodioCell) {
        cell.img.alpha = 1.0
        
        /*
        Initial rendering of a jpeg image can be expensive. To avoid stalling
        the main thread, we create an operation to process the `DataItem`'s
        image before updating the cell's image view.
        
        The execution block is added after the operation is created to allow
        the block to check if the operation has been cancelled.
        */
        let processImageOperation = NSBlockOperation()
        
        processImageOperation.addExecutionBlock { [unowned processImageOperation] in
            // Ensure the operation has not been cancelled.
            guard !processImageOperation.cancelled else { return }
            
            
            // Store the processed image in the cache.
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                // Check that the cell is still showing the same `DataItem`.
                
                // Update the cell's `UIImageView` and then fade it into view.
                cell.img.alpha = 0.0
                
                UIView.animateWithDuration(0.25) {
                    cell.img.alpha = 1.0
                }
            }
        }
    }   
}

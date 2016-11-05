//
//  ProgramaSelector.swift
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
import AVFoundation
import AVKit
import MediaPlayer

private let reuseIdentifier = "Cell"
class ProgramaSelector: UICollectionViewController, Observer {
    var data:Programa = Programa()   
    var avPlayer:AVPlayer = AVPlayer()
    var timer:Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        Crawler.sharedInstance.addObserver(self)
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ProgramaSelector.update), userInfo: nil, repeats: true)
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
    func update()
    {
        self.collectionView?.reloadData()
    }
    func invocar()
    {
        self.collectionView?.reloadData()
        timer?.invalidate()
        timer = nil
    }
    func observerID() -> String
    {
        return data.titulo
    }
    /**
     Establece una única sección para la colección
     */
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    /**
     Decimos el número de elementos que va a tener
     */
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.episodios.count
    }
    /**
     Este método permite configurar cada celda con los datos necesarios
     */
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let celda: EpisodioCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodioCell", for: indexPath) as? EpisodioCell
        {
            let episodio = data.episodios[indexPath.row]
            celda.configurar(episodio, programa: data.titulo)
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
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let commentView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! ViewHeaderPrograms
        commentView.logo = UIImageView(image: UIImage(named: "logo"))
        commentView.barra = UIImageView( image: UIImage(named: "barra"))
        return commentView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinoController: AVPlayerViewController = segue.destination as! AVPlayerViewController
        let cell:EpisodioCell = sender as! EpisodioCell
        let videoURL:URL = URL(string: cell.url)!
        self.avPlayer = AVPlayer(url: videoURL)
        destinoController.player = self.avPlayer
        destinoController.player?.play()
    }
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let indexPath = collectionView.indexPathsForSelectedItems?.first {
            collectionView.deselectItem(at: indexPath, animated: true)
            return false
        }
        else {
            return true
        }
    }
    override func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        guard let indexPaths = collectionView.indexPathsForSelectedItems else { return true }
        return indexPaths.isEmpty
    }
    /**
     Este método se encarga de establecer el foco
     */
   
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({
            context.previouslyFocusedView?.transform = CGAffineTransform.identity
            context.previouslyFocusedView?.layer.shadowColor = UIColor.clear.cgColor
            context.nextFocusedView?.transform = CGAffineTransform(scaleX: 1.10, y: 1.10)
            context.nextFocusedView?.layer.shadowColor = UIColor.black.cgColor
            context.nextFocusedView?.layer.shadowRadius = 8.0
            context.nextFocusedView?.layer.shadowOffset = CGSize(width: 0,height: 2)
            context.nextFocusedView?.layer.shadowOpacity = 1.0
            }, completion: nil)
    }
}

//
//  ImagesCache.swift
//  LaTuerka
//
//  Created by Fiser on 17/2/16.
//  Copyright © 2016 Fiser. All rights reserved.
//

import Foundation
import UIKit

class ImagesManager{
    static let sharedInstance = ImagesManager()
    func saveImage (image: UIImage, path: String ) -> Bool{
        let jpgImageData = UIImageJPEGRepresentation(image, 1.0)
        let result = jpgImageData!.writeToFile(path, atomically: true)
        return result
    }
    func loadImageFromPath(path: String) -> UIImage? {
        return UIImage(contentsOfFile: path)
    }
    func downloadImage(url: String, nombrePrograma: String) throws -> UIImage {
        if let urlNS:NSURL = NSURL(string: url){
            let imagePath = fileInDocumentsDirectory(nombrePrograma + "-" + urlNS.pathComponents!.last!)
            if let loadedImage = loadImageFromPath(imagePath) {
                return loadedImage
            } else {
                if let data:NSData = NSData(contentsOfURL: urlNS){ //make sure your image in this url does exist, otherwise unwrap in a if let check
                    if let imagen:UIImage = UIImage(data: data){
                        let imagenProcesada:UIImage = imageByCombiningImage(imageResize(imagen, sizeChange:  CGSizeMake(495, 300)))
                        saveImage(imagenProcesada, path: imagePath)
                        return imagenProcesada
                    }
                    else{
                        throw BadImage.Empty
                    }
                }
            }
        }
        return UIImage()
    }
    func imageByCombiningImage(firstImage: UIImage) -> UIImage {
        var image: UIImage? = nil
        let secondImage:UIImage = UIImage(named: "barra")!
        let newImageSize: CGSize = CGSizeMake(max(firstImage.size.width, secondImage.size.width), 320)
        UIGraphicsBeginImageContext(newImageSize)
        firstImage.drawAtPoint(CGPointMake(0,0))
        secondImage.drawAtPoint(CGPointMake(0,255))
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    func imageResize (imageObj:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    private func getDocumentsURL() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }
    private func fileInDocumentsDirectory(filename: String) -> String {
        
        let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
        return fileURL.path!
        
    }
}
enum BadImage: ErrorType {
    case Empty
}
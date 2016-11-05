//
//  ImagesCache.swift
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


import Foundation
import UIKit

class ImagesManager{
    static let sharedInstance = ImagesManager()
    func saveImage (_ image: UIImage, path: String ) -> Bool{
        let jpgImageData = UIImageJPEGRepresentation(image, 1.0)
        let result = (try? jpgImageData!.write(to: URL(fileURLWithPath: path), options: [.atomic])) != nil
        return result
    }
    func loadImageFromPath(_ path: String) -> UIImage? {
        return UIImage(contentsOfFile: path)
    }
    func downloadImage(_ url: String, nombrePrograma: String) throws -> UIImage {
        if let urlNS:URL = URL(string: url){
            let imagePath = fileInDocumentsDirectory(nombrePrograma + "-" + urlNS.pathComponents.last!)
            if let loadedImage = loadImageFromPath(imagePath) {
                return loadedImage
            } else {
                if let data:Data = try? Data(contentsOf: urlNS){ //make sure your image in this url does exist, otherwise unwrap in a if let check
                    if let imagen:UIImage = UIImage(data: data){
                        let imagenProcesada:UIImage = imageByCombiningImage(imageResize(imagen, sizeChange:  CGSize(width: 495, height: 300)))
                        saveImage(imagenProcesada, path: imagePath)
                        return imagenProcesada
                    }
                    else{
                        throw BadImage.empty
                    }
                }
            }
        }
        return UIImage()
    }
    func imageByCombiningImage(_ firstImage: UIImage) -> UIImage {
        var image: UIImage? = nil
        let secondImage:UIImage = UIImage(named: "barra")!
        let newImageSize: CGSize = CGSize(width: max(firstImage.size.width, secondImage.size.width), height: 320)
        UIGraphicsBeginImageContext(newImageSize)
        firstImage.draw(at: CGPoint(x: 0,y: 0))
        secondImage.draw(at: CGPoint(x: 0,y: 255))
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    func imageResize (_ imageObj:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    fileprivate func getDocumentsURL() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL
    }
    fileprivate func fileInDocumentsDirectory(_ filename: String) -> String {
        
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        return fileURL.path
        
    }
}
enum BadImage: Error {
    case empty
}

//
//  Crawler.swift
//  LaTuerka
//
//  Created by Fiser on 11/2/16.
//  Copyright © 2016 Fiser. All rights reserved.
//

import Foundation
import UIKit

class Crawler{
    static let sharedInstance = Crawler()
    var programas:[Programa] = [
        Programa(Imagen: UIImage(named: "laTuerkaActualidad")!, URL: "http://especiales.publico.es/publico-tv/la-tuerka/tuerka-actualidad", Titulo: "LA TUERKA ACTUALIDAD"),
        Programa(Imagen: UIImage(named: "elTornillo")!, URL: "http://especiales.publico.es/publico-tv/la-tuerka/el-tornillo", Titulo: "EL TORNILLO"),
        Programa(Imagen: UIImage(named: "laKlau")!, URL: "http://especiales.publico.es/publico-tv/la-tuerka/la-klau", Titulo: "LA KLAU"),
        Programa(Imagen: UIImage(named: "laTuerkaNews")!, URL: "http://especiales.publico.es/publico-tv/la-tuerka/tuerka-news", Titulo: "LA TUERKA NEWS"),
        Programa(Imagen: UIImage(named: "enClaveTuerka")!, URL: "http://especiales.publico.es/publico-tv/la-tuerka/en-clave-tuerka", Titulo: "EN CLAVE TUERKA"),
        Programa(Imagen: UIImage(named: "otraVueltaDeTuerka")!, URL: "http://especiales.publico.es/publico-tv/la-tuerka/otra-vuelta-de-tuerka", Titulo: "OTRA VUELTA DE TUERKA")]
    
    private init(){
        for programa in programas
        {
            self.descargarPortadas(URL: programa.url, Programa: programa)
        }
        for programa in programas
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                self.descargarProgramasBucle(Programa: programa, URL: programa.url)
                dispatch_async(dispatch_get_main_queue(), {
                    });
                });
        }
    }
    private func descargarPortadas(URL urlActual:String, Programa programa:Programa)
    {
        if let urlNS:NSURL = NSURL(string: urlActual)
        {
            if let data:NSData = NSData(contentsOfURL: urlNS)
            {
                let doc = TFHpple(HTMLData: data)
                if let elements = doc.searchWithXPathQuery("//ul[@class='program-list']/li") as? [TFHppleElement] {
                    let urlTag:TFHppleElement! = (elements.first!.searchWithXPathQuery("//a") as? [TFHppleElement])?.first
                    var url:String = "http://especiales.publico.es"+(urlTag?.objectForKey("href"))!
                    url = obtenerURLVideo(URL: url)
                    let imageURL:String! = (urlTag?.searchWithXPathQuery("//img") as? [TFHppleElement])?.first?.objectForKey("src")
                    programa.image = downloadImage(imageURL)
                }
            }
        }
    }

    func descargarProgramasBucle(Programa programa: Programa, URL urlActual: String)
    {
        
        if(urlActual != "#"){
            descargarRecursivamente(URL: urlActual, Programa: programa)
            if let urlNS:NSURL = NSURL(string: urlActual){
                if let data:NSData = NSData(contentsOfURL: urlNS){
                    let doc = TFHpple(HTMLData: data)
                    if let elements = doc.searchWithXPathQuery("//div[@class='navegation bottom']//ul//li[@class='next']//a") as? [TFHppleElement] {
                        descargarProgramasBucle(Programa: programa, URL: elements.first!.objectForKey("href"))
                    }
                }
            }
        }
    }
    private func descargarRecursivamente(URL urlActual:String, Programa programa:Programa)
    {
        if let urlNS:NSURL = NSURL(string: urlActual)
        {
            if let data:NSData = NSData(contentsOfURL: urlNS)
            {
                let doc = TFHpple(HTMLData: data)
                if let elements = doc.searchWithXPathQuery("//ul[@class='program-list']/li") as? [TFHppleElement] {
                    //De momento solo se baja los de la primera, solucionar
                    var controlFirst:Bool = false
                    for element in elements {
                        
                        let urlTag:TFHppleElement! = (element.searchWithXPathQuery("//a") as? [TFHppleElement])?.first
                        var url:String = "http://especiales.publico.es"+(urlTag?.objectForKey("href"))!
                        url = obtenerURLVideo(URL: url)
                        let titulo:String! = ((element.searchWithXPathQuery("//h3//a") as? [TFHppleElement])?.first)?.text()
                        let dateSTR:String! = ((element.searchWithXPathQuery("//h4//a//span") as? [TFHppleElement])?.first)?.text()
                        let imageURL:String! = (urlTag?.searchWithXPathQuery("//img") as? [TFHppleElement])?.first?.objectForKey("src")
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "dd-MM-yyyy"
                        let date = dateFormatter.dateFromString( dateSTR )
                        let episodio:Episodio = Episodio(URL: url, Imagen: downloadImage(imageURL), Fecha: date!, Titulo: titulo)
                        programa.episodios.append(episodio)
                        if(!controlFirst){
                            programa.image = episodio.image
                            controlFirst = true
                        }
                    }
                }
            }
        }
    }
    private func downloadImage(url: String) -> UIImage! {

        if let urlNS:NSURL = NSURL(string: url){
                if let data:NSData = NSData(contentsOfURL: urlNS){ //make sure your image in this url does exist, otherwise unwrap in a if let check
                    let imagen:UIImage! = UIImage(data: data)
                    return imageByCombiningImage(imageResize(imagen, sizeChange:  CGSizeMake(495, 320)))
                }
        }
        return UIImage()
    }

    func saveImage (image: UIImage, path: String ) -> Bool{
        let pngImageData = UIImagePNGRepresentation(image)
        let result = pngImageData!.writeToFile(path, atomically: true)
        return result
    }
    func imageResize (imageObj:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }

    func loadImageFromPath(path: String) -> UIImage? {
        let image = UIImage(contentsOfFile: path)
        return image
    }
    func obtenerURLVideo(URL urlActual: String) -> String
    {
        var urlFinal:String = ""
        if let urlNS:NSURL = NSURL(string: urlActual){
            if let data:NSData = NSData(contentsOfURL: urlNS){
                let doc = TFHpple(HTMLData: data)
                if let elements = doc.searchWithXPathQuery("//div[@class='codigo']") as? [TFHppleElement] {
                    if(elements.count != 0){
                        if elements.count != 0{
                            if elements[0].content.getURLs().count != 0{
                                urlFinal = String(elements[0].content.getURLs()[0])
                                urlFinal = urlFinal.substringToIndex(urlFinal.endIndex.predecessor())
                            }
                        }
                    }
                }
            }
        }

        return urlFinal
    }
    func imageByCombiningImage(firstImage: UIImage) -> UIImage {
        var image: UIImage? = nil
        let secondImage:UIImage = UIImage(named: "barra")!
        let newImageSize: CGSize = CGSizeMake(max(firstImage.size.width, secondImage.size.width), firstImage.size.height+80)
        UIGraphicsBeginImageContext(newImageSize)
        firstImage.drawAtPoint(CGPointMake(0,0))
        secondImage.drawAtPoint(CGPointMake(0,275))
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}
extension String {
    var length: Int {
        return self.characters.count
    }
    func getURLs() -> [NSURL] {
        let detector = try? NSDataDetector(types: NSTextCheckingType.Link.rawValue)
        
        let links = detector?.matchesInString(self, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, length)).map {$0 }
        
        return links!.filter { link in
            return link.URL != nil
            }.map { link -> NSURL in
                return link.URL!
        }
    }

}
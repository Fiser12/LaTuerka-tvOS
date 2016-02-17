//
//  Crawler.swift
//  LaTuerka
//
//  Created by Fiser on 11/2/16.
//  Copyright © 2016 Fiser. All rights reserved.
//

import Foundation
import UIKit

class Crawler: Observable{
    static let sharedInstance = Crawler()
    var observable:[Observer] = []
    var programas:[Programa] = [
        Programa(Imagen: UIImage(named: "laTuerkaActualidad")!, URL: "http://especiales.publico.es/publico-tv/la-tuerka/tuerka-actualidad", Titulo: "LA TUERKA ACTUALIDAD"),
        Programa(Imagen: UIImage(named: "elTornillo")!, URL: "http://especiales.publico.es/publico-tv/la-tuerka/el-tornillo", Titulo: "EL TORNILLO"),
        Programa(Imagen: UIImage(named: "laKlau")!, URL: "http://especiales.publico.es/publico-tv/la-tuerka/la-klau", Titulo: "LA KLAU"),
        Programa(Imagen: UIImage(named: "laTuerkaNews")!, URL: "http://especiales.publico.es/publico-tv/la-tuerka/tuerka-news", Titulo: "LA TUERKA NEWS"),
        Programa(Imagen: UIImage(named: "enClaveTuerka")!, URL: "http://especiales.publico.es/publico-tv/la-tuerka/en-clave-tuerka", Titulo: "EN CLAVE TUERKA"),
        Programa(Imagen: UIImage(named: "otraVueltaDeTuerka")!, URL: "http://especiales.publico.es/publico-tv/la-tuerka/otra-vuelta-de-tuerka", Titulo: "OTRA VUELTA DE TUERKA")]
    var checkFinish = 1;
    private init(){
        for programa in programas
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                self.descargarProgramasBucle(Programa: programa, URL: programa.url)
                dispatch_async(dispatch_get_main_queue(), {
                    if let elemento:Observer = self.observable.filter({$0.observerID() == programa.titulo}).first{
                        elemento.invocar()
                    }
                    if self.checkFinish != 6{
                        ++self.checkFinish
                    }
                    else{
                        if let elemento:Observer = self.observable.filter({$0.observerID() == "Central"}).first{
                            elemento.invocar()
                        }
                    }
                    });
                });
        }
    }
    func addObserver(observer:Observer)
    {
        observable.append(observer)
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
                    let dateSTR:String! = ((elements.first!.searchWithXPathQuery("//h4//a//span") as? [TFHppleElement])?.first)?.text()
                    let titulo:String! = ((elements.first!.searchWithXPathQuery("//h3//a") as? [TFHppleElement])?.first)?.text()
                    programa.image = ImagesManager.sharedInstance.downloadImage(imageURL, nombrePrograma: programa.titulo+"-"+titulo, fecha: dateSTR)
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
                        let episodio:Episodio = Episodio(URL: url, Imagen: ImagesManager.sharedInstance.downloadImage(imageURL, nombrePrograma: programa.titulo+"-"+titulo, fecha: dateSTR), Fecha: date!, Titulo: titulo)
                        programa.episodios.append(episodio)
                    }
                }
            }
        }
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
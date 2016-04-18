//
//  Crawler.swift
//  LaTuerka
//
//  Created by Fiser on 11/2/16.
//  Copyright © 2016 Fiser. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class Crawler: Observable{
    static let sharedInstance = Crawler()
    var observable:[Observer] = []
    var programas:[Programa] = [
        Programa(Imagen: UIImage(named: "laTuerkaActualidad")!, URL: "http://especiales.publico.es/publico-tv/la-tuerka/videoblog-de-monedero", Titulo: "VIDEOBLOG DE MONEDERO"),
        Programa(Imagen: UIImage(named: "elTornillo")!, URL: "http://especiales.publico.es/publico-tv/la-tuerka/el-tornillo", Titulo: "EL TORNILLO"),
        Programa(Imagen: UIImage(named: "laKlau")!, URL: "http://especiales.publico.es/publico-tv/la-tuerka/la-klau", Titulo: "LA KLAU"),
        Programa(Imagen: UIImage(named: "laTuerkaNews")!, URL: "http://especiales.publico.es/publico-tv/la-tuerka/tuerka-news", Titulo: "LA TUERKA NEWS"),
        Programa(Imagen: UIImage(named: "enClaveTuerka")!, URL: "http://especiales.publico.es/publico-tv/la-tuerka/en-clave-tuerka", Titulo: "EN CLAVE TUERKA"),
        Programa(Imagen: UIImage(named: "otraVueltaDeTuerka")!, URL: "http://especiales.publico.es/publico-tv/la-tuerka/otra-vuelta-de-tuerka", Titulo: "OTRA VUELTA DE TUERKA")]
    var comprobarProgramas:[String] = []
    private init(){
        for programa in programas
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//                programa.episodios.appendContentsOf(self.convert(DataController.sharedInstance.loadEpisodios(programa.titulo)!))
                self.descargarProgramasBucle(Programa: programa, URL: programa.url)
                dispatch_async(dispatch_get_main_queue(), {
                    if let elemento:Observer = self.observable.filter({$0.observerID() == programa.titulo}).first{
                        elemento.invocar()
                    }
                    });
                });
        }
    }
    func convert(episodios:[EpisodioEntity]) -> [Episodio]
    {
        var episodiosConvertidos:[Episodio] = []
        for episodio:EpisodioEntity in episodios{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            do {
                let imagen:UIImage = try ImagesManager.sharedInstance.downloadImage(episodio.urlDir!, nombrePrograma: episodio.programa!+"-"+episodio.nombre!)
                episodiosConvertidos.append(Episodio(URL: episodio.urlDir!, Imagen: imagen, Titulo: episodio.nombre!))
                
            } catch {
                
            }
        }
        return episodiosConvertidos
    }
    func comprobar(id:String)
    {
        if !comprobarProgramas.contains(id)
        {
            comprobarProgramas.append(id)
            if comprobarProgramas.count == 6{
                if let elemento:Observer = self.observable.filter({$0.observerID() == "Central"}).first{
                    dispatch_async(dispatch_get_main_queue(), {
                        elemento.invocar()
                    });
                }
            }
        }
    }
    func addObserver(observer:Observer)
    {
        observable.append(observer)
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
                if let elements = doc.searchWithXPathQuery("//div[@class='list']/div[not(@class='robapaginas')]") as? [TFHppleElement] {
                    for element in elements {
                        let urlTag:TFHppleElement! = (element.searchWithXPathQuery("//a") as? [TFHppleElement])?.first
                        var url:String = "http://especiales.publico.es"+(urlTag?.objectForKey("href"))!
                        print(url)
                        url = obtenerURLVideo(URL: url)
                        let titulo:String! = ((element.searchWithXPathQuery("//h4//a") as? [TFHppleElement])?.first)?.text()
//                        let dateSTR:String! = ((element.searchWithXPathQuery("//h4//a//span") as? [TFHppleElement])?.first)?.text()
                        let imageURL:String! = (urlTag?.searchWithXPathQuery("//img") as? [TFHppleElement])?.first?.objectForKey("src")
//                        let dateFormatter = NSDateFormatter()
//                        dateFormatter.dateFormat = "dd-MM-yyyy"
//                        let date = dateFormatter.dateFromString( dateSTR )
                        if url != ""{
                            do {
                                let imagen:UIImage = try ImagesManager.sharedInstance.downloadImage(imageURL, nombrePrograma: programa.titulo+"-"+titulo)
                                let episodio:Episodio = Episodio(URL: url, Imagen: imagen, Titulo: titulo)
                                programa.episodios.append(episodio)
                                comprobar(programa.titulo)
                            } catch {
                            
                            }
                        }
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
                
                if let elements = doc.searchWithXPathQuery("//div[@id='main']") as? [TFHppleElement] {
                    print(elements.count)
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
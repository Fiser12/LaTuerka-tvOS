//
//  Crawler.swift
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
import CoreData
class Crawler: Observable{
    static let sharedInstance = Crawler()
    var observable:[Observer] = []
    var programas:[Programa] = [
        Programa(Imagen: UIImage(named: "videoblogMonedero")!, URL: "http://especiales.publico.es/publico-tv/la-tuerka/videoblog-de-monedero", Titulo: "VIDEOBLOG DE MONEDERO"),
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
                self.descargarProgramasBucle(Programa: programa, URL: programa.url)
                dispatch_async(dispatch_get_main_queue(), {
                    if let elemento:Observer = self.observable.filter({$0.observerID() == programa.titulo}).first{
                        elemento.invocar()
                    }
                    });
                });
        }
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
                        url = obtenerURLVideo(URL: url)
                        let titulo:String! = ((element.searchWithXPathQuery("//h4//a") as? [TFHppleElement])?.first)?.text()
                        let imageURL:String! = (urlTag?.searchWithXPathQuery("//img") as? [TFHppleElement])?.first?.objectForKey("src")
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
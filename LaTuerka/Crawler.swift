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
    fileprivate init(){
        for programa in programas
        {
            DispatchQueue.global().async(execute: {
                self.descargarProgramasBucle(Programa: programa, URL: programa.url)
                DispatchQueue.main.async(execute: {
                    if let elemento:Observer = self.observable.filter({$0.observerID() == programa.titulo}).first{
                        elemento.invocar()
                    }
                    });
                });
        }
    }
    func comprobar(_ id:String)
    {
        if !comprobarProgramas.contains(id)
        {
            comprobarProgramas.append(id)
            if comprobarProgramas.count == 6{
                if let elemento:Observer = self.observable.filter({$0.observerID() == "Central"}).first{
                    DispatchQueue.main.async(execute: {
                        elemento.invocar()
                    });
                }
            }
        }
    }
    func addObserver(_ observer:Observer)
    {
        observable.append(observer)
    }
    func descargarProgramasBucle(Programa programa: Programa, URL urlActual: String)
    {
        if(urlActual != "#"){
            descargarRecursivamente(URL: urlActual, Programa: programa)
            if let urlNS:URL = URL(string: urlActual){
                if let data:Data = try? Data(contentsOf: urlNS){
                    let doc = TFHpple(htmlData: data)
                    if let elements = doc?.search(withXPathQuery: "//div[@class='navegation bottom']//ul//li[@class='next']//a") as? [TFHppleElement] {
                        descargarProgramasBucle(Programa: programa, URL: elements.first!.object(forKey: "href"))
                    }
                }
            }
        }
    }
    fileprivate func descargarRecursivamente(URL urlActual:String, Programa programa:Programa)
    {
        if let urlNS:URL = URL(string: urlActual)
        {
            if let data:Data = try? Data(contentsOf: urlNS)
            {
                let doc = TFHpple(htmlData: data)
                if let elements = doc?.search(withXPathQuery: "//div[@class='list']/div[not(@class='robapaginas')]") as? [TFHppleElement] {
                    for element in elements {
                        let urlTag:TFHppleElement! = (element.search(withXPathQuery: "//a") as? [TFHppleElement])?.first
                        var url:String = "http://especiales.publico.es"+(urlTag?.object(forKey: "href"))!
                        url = obtenerURLVideo(URL: url)
                        let titulo:String! = ((element.search(withXPathQuery: "//h4//a") as? [TFHppleElement])?.first)?.text()
                        let imageURL:String! = (urlTag?.search(withXPathQuery: "//img") as? [TFHppleElement])?.first?.object(forKey: "src")
                        if url != ""{
                            let episodio:Episodio = Episodio(URL: url, Imagen: imageURL, Titulo: titulo)
                            programa.episodios.append(episodio)
                            comprobar(programa.titulo)
                        }
                    }
                }
            }
        }
        
    }
    
    func obtenerURLVideo(URL urlActual: String) -> String
    {
        let urlFinal:String = "";
        guard let myURL = URL(string: urlActual) else {
            print("Error: \(urlActual) doesn't seem to be a valid URL")
            return ""
        }
        do {
            let regex:String = "\\{\"file\":\"(.*)\",\"label\":"
            let testStr = try String(contentsOf: myURL, encoding: .ascii)

            let nsRegularExpression = try! NSRegularExpression(pattern: regex, options: [])
            let matches = nsRegularExpression.matches(in: testStr, options: [], range: NSRange(location: 0, length: testStr.characters.count))
            if matches.isEmpty{
                return "";
            }
            for index in 1..<matches[0].numberOfRanges {
                return ((testStr as NSString).substring(with: matches[0].range(at: index)))
            }

        } catch let error {
            print("Error: \(error)")
        }

        return urlFinal
    }
}
extension String {
    var length: Int {
        return self.characters.count
    }
    func getURLs() -> [URL] {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        let links = detector?.matches(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, length)).map {$0 }
        
        return links!.filter { link in
            return link.url != nil
            }.map { link -> URL in
                return link.url!
        }
    }

}

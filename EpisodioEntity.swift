//
//  Episodio.swift
//  LaTuerka
//
//  Created by Fiser on 13/3/16.
//  Copyright © 2016 Fiser. All rights reserved.
//

import Foundation
import CoreData


class EpisodioEntity: NSManagedObject {
    @NSManaged var id: String?
    @NSManaged var fecha: String?
    @NSManaged var nombre: String?
    @NSManaged var urlDir: String?
    @NSManaged var programa: String?

}

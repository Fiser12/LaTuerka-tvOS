//
//  Observable.swift
//  LaTuerka
//
//  Created by Fiser on 17/2/16.
//  Copyright © 2016 Fiser. All rights reserved.
//

import Foundation
protocol Observable {
    func addObserver(observer:Observer)
}
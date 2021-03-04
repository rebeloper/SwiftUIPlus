//
//  CGSize+Hashable.swift
//  
//
//  Created by Alex Nagy on 04.03.2021.
//

import CoreGraphics

extension CGSize: Hashable {
     public func hash(into hasher: inout Hasher) {
         hasher.combine(width)
         hasher.combine(height)
     }
 }

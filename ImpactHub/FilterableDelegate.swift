//
//  Filterable.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 28/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation

protocol FilterableDelegate: class {
    func updateFilters(filters: [Filter])
}

//
//  FilterManager.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 28/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation

class FilterManager {

    public enum Source {
        case members
    }
    
    var currenttlySelectingFor: Source = .members
    
    
    var membersFilters = [Filter]()
    
    
    func clear(grouping: Filter.Grouping) {
        switch currenttlySelectingFor {
        case .members:
            let toRemain = membersFilters.filter({$0.grouping != grouping})
            membersFilters = toRemain
        }
    }

    func clearAll() {
        switch currenttlySelectingFor {
        case .members:
            membersFilters.removeAll()
        }
    }

    func getCurrentFilters() -> [Filter] {
        switch currenttlySelectingFor {
        case .members:
            return membersFilters
        }
    }
    
    func addFilter(filter: Filter) {
        switch currenttlySelectingFor {
        case .members:
            if !membersFilters.contains(filter) {
                membersFilters.append(filter)
            }
        }
    }
    
    func removeFilter(filter : Filter) {
        switch currenttlySelectingFor {
        case .members:
            membersFilters = membersFilters.filter({$0 != filter})
        }
    }

    
    static let shared = FilterManager()
}

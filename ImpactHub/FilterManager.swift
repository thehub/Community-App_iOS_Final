//
//  FilterManager.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 28/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation
import UIKit


protocol FilterManagerSource {
    var filterSource: FilterManager.Source { get }
}


class FilterManager {

    public enum Source {
        case members
        case companies
        case events
        case projects
        case jobs
        case groups
    }
    
    var currenttlySelectingFor: Source = .members
    
    var filterData = [[CellRepresentable]]()
    var dataViewModel = [CellRepresentable]()

    
    var membersFilters = [Filter]()
    var companiesFilters = [Filter]()
    var projectsFilters = [Filter]()
    var groupsFilters = [Filter]()
    var eventsFilters = [Filter]()
    var jobsFilters = [Filter]()
    
    
    func clear(grouping: Filter.Grouping) {
        switch currenttlySelectingFor {
        case .members:
            let toRemain = membersFilters.filter({$0.grouping != grouping})
            membersFilters = toRemain
            break
        case .companies:
            let toRemain = companiesFilters.filter({$0.grouping != grouping})
            companiesFilters = toRemain
            break
        case .events:
            let toRemain = eventsFilters.filter({$0.grouping != grouping})
            eventsFilters = toRemain
            break
        case .projects:
            let toRemain = projectsFilters.filter({$0.grouping != grouping})
            projectsFilters = toRemain
            break
        case .groups:
            let toRemain = groupsFilters.filter({$0.grouping != grouping})
            groupsFilters = toRemain
            break
        case .jobs:
            let toRemain = jobsFilters.filter({$0.grouping != grouping})
            jobsFilters = toRemain
            break
        }
    }

    func clearAll() {
        switch currenttlySelectingFor {
        case .members:
            membersFilters.removeAll()
        case .companies:
            companiesFilters.removeAll()
        case .events:
            eventsFilters.removeAll()
        case .projects:
            projectsFilters.removeAll()
        case .groups:
            groupsFilters.removeAll()
        case .jobs:
            jobsFilters.removeAll()
        }
    }

    func getCurrentFilters() -> [Filter] {
        switch currenttlySelectingFor {
        case .members:
            return membersFilters
        case .companies:
            return companiesFilters
        case .events:
            return eventsFilters
        case .projects:
            return projectsFilters
        case .groups:
            return groupsFilters
        case .jobs:
            return jobsFilters
        }
    }
    
    func getCurrentFilters(source: Source) -> [Filter] {
        switch source {
        case .members:
            return membersFilters
        case .companies:
            return companiesFilters
        case .events:
            return eventsFilters
        case .projects:
            return projectsFilters
        case .groups:
            return groupsFilters
        case .jobs:
            return jobsFilters
        }
    }
    
    func addFilter(filter: Filter) {
        switch currenttlySelectingFor {
        case .members:
            if !membersFilters.contains(filter) {
                membersFilters.append(filter)
            }
        case .companies:
            if !companiesFilters.contains(filter) {
                companiesFilters.append(filter)
            }
        case .events:
            if !eventsFilters.contains(filter) {
                eventsFilters.append(filter)
            }
        case .projects:
            if !projectsFilters.contains(filter) {
                projectsFilters.append(filter)
            }
        case .groups:
            if !groupsFilters.contains(filter) {
                groupsFilters.append(filter)
            }
        case .jobs:
            if !jobsFilters.contains(filter) {
                jobsFilters.append(filter)
            }
        }
    }
    
    func removeFilter(filter : Filter) {
        switch currenttlySelectingFor {
        case .members:
            membersFilters = membersFilters.filter({$0 != filter})
        case .companies:
            companiesFilters = companiesFilters.filter({$0 != filter})
        case .events:
            eventsFilters = eventsFilters.filter({$0 != filter})
        case .projects:
            projectsFilters = projectsFilters.filter({$0 != filter})
        case .groups:
            groupsFilters = groupsFilters.filter({$0 != filter})
        case .jobs:
            jobsFilters = jobsFilters.filter({$0 != filter})
        }
    }

    func clearPreviousFilters() {
        FilterManager.shared.filterData.removeAll(keepingCapacity: false)
        FilterManager.shared.dataViewModel.removeAll(keepingCapacity: false)
    }
    
    // This searches thorugh the objects to check respective filter preoprties and build up the filters. Called from MembersViewController etc
    func addFilters(fromTags tags: Set<String>, forGrouping grouping: Filter.Grouping) {
        let sortedItems: [Filter]
        // Size won't work with alpha sorting
        if grouping == .size {
            sortedItems = tags.map({Filter(grouping: grouping, name: $0)}).sorted(by: { (filterA, filterB) -> Bool in
                if let value1 = Int("\(filterA.name.substring(to: filterA.name.index(filterA.name.startIndex, offsetBy: 3)))".trimmingCharacters(in: CharacterSet.whitespaces)), let value2 = Int("\(filterB.name.substring(to: filterB.name.index(filterB.name.startIndex, offsetBy: 3)))".trimmingCharacters(in: CharacterSet.whitespaces)) {
                    return value1 < value2
                }
                else {
                    return false
                }
            })
        }
        else {
            sortedItems = tags.map({Filter(grouping: grouping, name: $0)}).sorted(by: {$0.name < $1.name})
        }
        if let first = sortedItems.first {
            let groupingVM = FilterGroupingViewModel(grouping: first.grouping, cellSize: CGSize(width: 0, height: 37))
            let filters = sortedItems.map({FilterViewModel(filter: $0, cellSize: CGSize(width: 0, height: 37))})
            self.dataViewModel.append(groupingVM)
            self.filterData.append(filters)
        }
    }
    
    static let shared = FilterManager()
}

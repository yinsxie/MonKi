//
//  MainRoute.swift
//  MonKi
//
//  Created by William on 28/10/25.
//

enum MainRoute: Hashable {
    case parentHome(ParentRoute)
    case childLog(ChildLogRoute)
    case childGarden(ChildGardenRoute)
    case reLog(log: MsLog)
    case parentValue
    case parentalGate
}

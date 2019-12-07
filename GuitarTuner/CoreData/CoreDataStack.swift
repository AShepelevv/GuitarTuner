//
//  CoreDataStack.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 05/12/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import Foundation
import CoreData

internal final class CoreDataStack {

    static let shared: CoreDataStack = {
        let coreDataStack = CoreDataStack()
        return coreDataStack
    }()

    let persistentContainer: NSPersistentContainer

    private init() {
        let group = DispatchGroup()
        persistentContainer = NSPersistentContainer(name: "Datamodel")
        group.enter()
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
            group.leave()
        }
        group.wait()
    }
}

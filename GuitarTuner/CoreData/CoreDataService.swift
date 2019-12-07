//
//  CoreDataService.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 05/12/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import Foundation
import CoreData

class CoreDataService {
    
    let stack = CoreDataStack.shared
    let viewContext = CoreDataStack.shared.persistentContainer.viewContext
    let backgroundContext = CoreDataStack.shared.persistentContainer.newBackgroundContext()

    func save(title: String, link: String) -> MOTabs? {
        let tabs = MOTabs(context: viewContext)
        tabs.title = title
        tabs.link = link
        return tabs
    }
    
    func delete(_ tabs: MOTabs) {
        guard let context = tabs.managedObjectContext else { return }
        context.delete(tabs)
        do {
            try context.save()
        } catch {
            print("Deletion is not succeded")
        }
    }
    
    func saveContext() -> Bool {
        do {
            try viewContext.save()
            return true
        } catch {
            print("Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
            return false
        }
    }
    
    func getFetcResultsController() -> NSFetchedResultsController<MOTabs> {
        let fetchRequest = NSFetchRequest<MOTabs>(entityName: "Tabs")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: viewContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        do {
            try controller.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        return controller
    }
}

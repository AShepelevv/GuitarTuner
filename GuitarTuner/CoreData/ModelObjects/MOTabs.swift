//
//  Tabs.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 05/12/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(MOTabs)
internal class MOTabs: NSManagedObject {
    @NSManaged var title: String
    @NSManaged var link: String
}

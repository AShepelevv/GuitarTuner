//
//  TabsViewController.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 27/11/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import UIKit
import CoreData

class TabsViewController: UIViewController {
    
    var tableView = UITableView()
    let coreDataService = CoreDataService()
    var tabsList: [MOTabs] = []
    let refreshControll = UIRefreshControl()
    var fetchResultController: NSFetchedResultsController<MOTabs>!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: "Tabs", image: UIImage(named: "tabs"), selectedImage: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let button = UIButton()
        button.imageView?.image = UIImage(named: "plus")
        button.addTarget(self, action: #selector(addTabs), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButtonItem
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TabsTableViewCell.self, forCellReuseIdentifier: TabsTableViewCell.reuseID)
        tableView.frame = view.frame
        tableView.backgroundColor = .white
        
        self.fetchResultController = coreDataService.getFetcResultsController()
        self.fetchResultController.delegate = self
        self.tableView.reloadData()
        
        view.addSubview(tableView)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
    
    @objc
    func applicationDidEnterBackground(_ notification: Notification) {
        _ = coreDataService.saveContext()
    }
    
    @objc
    private func addTabs() {
        let alert = UIAlertController(title: "Something went bab with network", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: { $0.placeholder = "Title" })
        alert.addTextField(configurationHandler: { $0.placeholder = "Link" })
        alert.addAction(
            UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { _ in
                guard let title = alert.textFields?[0].text else { return }
                guard let link = alert.textFields?[1].text else { return }
                
                _ = self.coreDataService.save(title: title, link: link)
            })
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension TabsViewController: UITableViewDelegate {
    
}

extension TabsViewController: UITableViewDataSource {
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        if let frc = fetchResultController {
    //            return frc.sections!.count
    //        }
    //        return 0
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchResultController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.objects!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellOrNil = tableView.dequeueReusableCell(withIdentifier: TabsTableViewCell.reuseID, for: indexPath) as? TabsTableViewCell
        guard let cell = cellOrNil else {
            return UITableViewCell()
        }
        guard let tabs = self.fetchResultController?.object(at: indexPath) else {
            cell.textLabel?.text = "<NONAME>"
            fatalError("Attempt to configure cell without a managed object")
        }
        cell.textLabel?.text = tabs.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tabs = self.fetchResultController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        let webVC = WebViewController()
        webVC.link = tabs.link
        webVC.title = tabs.title
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            print("1")
            let tabs = fetchResultController.object(at: indexPath)
            //            fetchResultController.managedObjectContext.delete(tabs)
            coreDataService.delete(tabs)
        default:
            print("$__$")
        }
    }
    
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        guard let sectionInfo = fetchResultController?.sections?[section] else {
    //            return nil
    //        }
    //        return sectionInfo.name
    //    }
    
    //    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    //        return fetchResultController?.sectionIndexTitles
    //    }
    //
    //    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
    //        guard let result = fetchResultController?.section(forSectionIndexTitle: title, at: index) else {
    //            fatalError("Unable to locate section for \(title) at index: \(index)")
    //        }
    //        return result
    //    }
}

extension TabsViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("=)")
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("=(")
        self.tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            print(2)
            self.tableView.reloadSections([0], with: .middle)
            if let indexPath = newIndexPath {
                tableView.deleteRows(at: [indexPath], with: .left)
            }
        default:
            print("0__0")
        }
    }
    
    //    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
    //                    didChange sectionInfo: NSFetchedResultsSectionInfo,
    //                    atSectionIndex sectionIndex: Int,
    //                    for type: NSFetchedResultsChangeType) {
    //        <#code#>
    //    }
}

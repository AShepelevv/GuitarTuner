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
    
    // MARK: - Properties
    
    let coreDataService = CoreDataService()
    var tabsList: [MOTabs] = []
    var fetchResultController: NSFetchedResultsController<MOTabs>!
    
    // MARK: - UI
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TabsTableViewCell.self, forCellReuseIdentifier: TabsTableViewCell.reuseID)
        tableView.frame = view.frame
        tableView.backgroundColor = Color.white
        return tableView
    }()
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Tabs"
        tabBarItem = UITabBarItem(title: self.title, image: UIImage(named: "tabs"), selectedImage: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        let button = UIButton()
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.addTarget(self, action: #selector(addTabs), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButtonItem
        
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
        alert.addTextField(configurationHandler: {
            $0.placeholder = "Link"
            if let copiedText = UIPasteboard.general.string {
                $0.text = copiedText
            } else {
                $0.placeholder = "Link"
            }
        })
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

// MARK: - UITableViewDelegatele

extension TabsViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension TabsViewController: UITableViewDataSource {
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let tabs = fetchResultController.object(at: indexPath)
            coreDataService.delete(tabs)
        default: break
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegatex

extension TabsViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
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
            self.tableView.reloadSections([0], with: .middle)
            if let indexPath = newIndexPath {
                tableView.deleteRows(at: [indexPath], with: .left)
            }
        default: break
        }
    }
}

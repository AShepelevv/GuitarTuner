//
//  TabsViewController.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 27/11/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import UIKit

class TabsViewController: UIViewController {
//    
//    var tableView = UITableView()
//    var tabsList: [Tabs] = []
//    let networkService = NetworkService()
//    let refreshControll = UIRefreshControl()
//
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        tabBarItem = UITabBarItem(title: "Tabs", image: UIImage(named: "tabs"), selectedImage: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.backgroundColor = .white
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(TabsTableViewCell.self, forCellReuseIdentifier: TabsTableViewCell.reuseID)
//        tableView.frame = view.frame
//        tableView.backgroundColor = .white
//        tableView.refreshControl = refreshControll
//        
//        refreshControll.addTarget(self, action: #selector(updateTabsFromWeb), for: .valueChanged)
//        
//        view.addSubview(tableView)
//        
//        updateTabsFromWeb()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.navigationBar.isHidden = true
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        navigationController?.navigationBar.isHidden = false
//    }
//    
//    @objc
//    private func updateTabsFromWeb() {
////        networkService.getTabs(completion: { tabsList in
////            self.tabsList = tabsList
////            DispatchQueue.main.sync {
////                self.tableView.reloadData()
////                self.refreshControll.endRefreshing()
////            }
////        })
//    }
//}
//
//extension TabsViewController : UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let webVC = WebViewController()
//        let tabs = tabsList[indexPath.row]
//        webVC.link = tabs.link
//        webVC.title = tabs.name
//        navigationController?.pushViewController(webVC, animated: true)
//    }
//}
//
//extension TabsViewController : UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        tabsList.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: TabsTableViewCell.reuseID, for: indexPath) as! TabsTableViewCell
//        cell.textLabel?.text = tabsList[indexPath.row].name
//        return cell
//    }
}

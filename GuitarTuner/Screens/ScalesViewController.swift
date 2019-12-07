//
//  ScaleViewController.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 27/11/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import UIKit

class ScalesViewController: UIViewController {
    
    var scales: [GuitarScale] = []
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ScaleCollectionViewCell.self, forCellWithReuseIdentifier: ScaleCollectionViewCell.reuseID)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        
        return collectionView
    }()
    
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.layer.zPosition = -1
        spinner.startAnimating()
        return spinner
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: "Scales", image: UIImage(named: "scale"), selectedImage: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if scales.isEmpty {
            updateScalesFromWeb()
        }
    }
    
    override func viewWillLayoutSubviews() {
        view.addSubview(collectionView)
        view.addSubview(spinner)
        
        let safeArea = view.safeAreaLayoutGuide
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
        spinner.startAnimating()
        spinner.widthAnchor.constraint(equalToConstant: 50).isActive = true
        spinner.heightAnchor.constraint(equalTo: spinner.widthAnchor).isActive = true
    }
    
    private func updateScalesFromWeb() {
        ScalesNetworkService().get(completion: { scalesOrNil in
            guard let scales = scalesOrNil else {
                DispatchQueue.main.async {
                    self.showAlert()
                }
                return
            }
            self.scales = scales
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.spinner.stopAnimating()
            }
            
        })
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Something went bab with network", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ScalesViewController: UICollectionViewDelegate {
    
}

extension ScalesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scales.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellOrNil = collectionView.dequeueReusableCell(withReuseIdentifier: ScaleCollectionViewCell.reuseID,
                                                           for: indexPath) as? ScaleCollectionViewCell
        guard let cell = cellOrNil else {
            return UICollectionViewCell()
        }
        let scale = scales[indexPath.row]
        cell.titleLabel.text = scale.name
        cell.scaleLabel.text = scale.notes.reduce("", { (result, element) in
            let newResult = result! + element + " "
            return newResult
        })
        cell.imageView.image = UIImage(data: scale.imageData)
        return cell
    }
}

extension ScalesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}

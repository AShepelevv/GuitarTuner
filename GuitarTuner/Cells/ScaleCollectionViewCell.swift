//
//  ScaleTableViewCell.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 28/11/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import UIKit

class ScaleCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    
    static let reuseID: String = "ScaleCollectionViewCell"
    static let MARGIN: CGFloat = 10.0

    // MARK: - UI
    
    let insideView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.orange
        view.layer.cornerRadius = MARGIN
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = MARGIN
        view.layer.shadowOpacity = 1.0
        return view
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = MARGIN
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.graphite
        label.textAlignment = .center
        let fontDescriptor = UIFont.systemFont(ofSize: 30.0, weight: .bold).fontDescriptor
        label.font = UIFont(name: Settings.fontName, size: 27)
        label.adjustsFontSizeToFitWidth = true
        label.text = ""
        label.numberOfLines = 0
        return label
    }()

    let scaleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.graphite
        label.textAlignment = .center
        label.font = UIFont(name: Settings.fontName, size: 27)
        label.adjustsFontSizeToFitWidth = true
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        layoutSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout

    override func layoutSubviews() {
        contentView.addSubview(insideView)
        insideView.addSubview(titleLabel)
        insideView.addSubview(scaleLabel)
        insideView.addSubview(imageView)

        insideView.translatesAutoresizingMaskIntoConstraints = false
        insideView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2 * ScaleCollectionViewCell.MARGIN).isActive = true
        insideView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2 * ScaleCollectionViewCell.MARGIN).isActive = true
        insideView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2 * ScaleCollectionViewCell.MARGIN).isActive = true
        insideView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2 * ScaleCollectionViewCell.MARGIN).isActive = true

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: insideView.topAnchor, constant: 2 * ScaleCollectionViewCell.MARGIN).isActive = true
        imageView.leadingAnchor.constraint(equalTo: insideView.leadingAnchor, constant: 2 * ScaleCollectionViewCell.MARGIN).isActive = true
        imageView.trailingAnchor.constraint(equalTo: insideView.trailingAnchor, constant: -2 * ScaleCollectionViewCell.MARGIN).isActive = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(greaterThanOrEqualTo: imageView.bottomAnchor, constant: 2 * ScaleCollectionViewCell.MARGIN).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: insideView.leadingAnchor, constant: ScaleCollectionViewCell.MARGIN).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: insideView.trailingAnchor, constant: -ScaleCollectionViewCell.MARGIN).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        scaleLabel.translatesAutoresizingMaskIntoConstraints = false
        scaleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScaleCollectionViewCell.MARGIN).isActive = true
        scaleLabel.bottomAnchor.constraint(equalTo: insideView.bottomAnchor, constant: -ScaleCollectionViewCell.MARGIN).isActive = true
        scaleLabel.leadingAnchor.constraint(equalTo: insideView.leadingAnchor, constant: 2 * ScaleCollectionViewCell.MARGIN).isActive = true
        scaleLabel.trailingAnchor.constraint(equalTo: insideView.trailingAnchor, constant: -2 * ScaleCollectionViewCell.MARGIN).isActive = true
        scaleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

}

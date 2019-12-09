//
//  ScaleTableViewCell.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 28/11/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import UIKit

class TabsTableViewCell: UITableViewCell {

    static let reuseID: String = "TabTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: ScaleCollectionViewCell.reuseID)
        backgroundColor = .clear
        textLabel?.textColor = Color.graphite
        textLabel?.font = UIFont(name: "Courier", size: 15)
        self.selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

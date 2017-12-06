//
//  VersionTableViewCell.swift
//  ShoeOsVersion
//
//  Created by Magnolia on 04.12.2017.
//  Copyright © 2017 Mangust. All rights reserved.
//

import Foundation
import UIKit

class VersionTableViewCell: UITableViewCell {
    
    // MARK: - Type Properties
    
    static let reuseIdentifier = "VersionCell"
    
    // MARK: - Properties
    
    @IBOutlet var mainLabel: UILabel!
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Configuration
    
    func configure(withViewModel viewModel: VersionsViewModel) {
        
        self.mainLabel.text = viewModel.title
        
    }
    
}

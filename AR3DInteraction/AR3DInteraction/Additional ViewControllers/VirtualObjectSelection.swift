//
//  VirtualObjectSelection.swift
//  AR3DInteraction
//
//  Created by Henry Morris on 29/11/2018.
//  Copyright © 2018 Altair. All rights reserved.
//

import UIKit
import ARKit

// MARK: - ObjectCell

class ObjectCell: UITableViewCell {
    static let reuseIdentifier = "ObjectCell"
    
    @IBOutlet weak var objectTitleLabel: UILabel!
    @IBOutlet weak var objectImageView: UIImageView!
    @IBOutlet weak var vibrancyView: UIVisualEffectView!
    
    var modelName = "" {
        didSet {
            objectTitleLabel.text = modelName.capitalized
            objectImageView.image = UIImage(named: modelName)
        }
    }
}

// MARK: - VirtualObjectSelectionViewControllerDelegate

/// A protocol for reporting which objects have been selected
protocol VirtualObjectSelectionViewControllerDelegate: class {
}

/// Custom table view controller to allow users to select 'VirtualObject's for placement in the scene
class VirtualObjectSelectionViewController: UITableViewController {
    
}

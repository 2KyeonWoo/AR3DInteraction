//
//  FocusSquare.swift
//  AR3DInteraction
//
//  Created by Henry Morris on 29/11/2018.
//  Copyright © 2018 Altair. All rights reserved.
//

import Foundation
import ARKit

/**
 'SCNNode' which is used to provide uses with visual cues about the status of ARKit world tracking.
 - Tag: FocusSquare
 */
class FocusSquare: SCNNode {
    // MARK: - Types
    
    enum State: Equatable {
        case initializing
        case detecting(hitTestResult: ARHitTestResult, camera: ARCamera?)
    }
    
    // MARK: - Configuration Properties
    
    // Original size of the focus square in meters.
    static let size: Float = 0.17
    
    // Thickness of the focus square lines in meters.
    static let thickness: Float = 0.018
    
    // Scale factor for the focus square when it is closed, w.r.t. the original size.
    static let scaleForClosedSquare: Float = 0.97
    
    // Side length of the focus square segments when it is open (w.r.t. to a 1x1 square).
    static let sideLengthForOpenSegments: CGFloat = 0.2
    
    // Duration of the open/close animation
    static let animationDuration = 0.7
    
    static let primaryColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
    
    // Color of the focus square fill.
    static let fillColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
    
    // MARK: - Properties
    
    /// The most recent position of the focus square based on the current state.
    var lastPosition: float3? {
        switch state {
        case .initializing: return nil
        case .detecting(let hitTestResult, _): return
            hitTestResult.worldTransform.translation
        }
    }
    
    var state: State = .initializing {
        didSet {
            guard state != oldValue else { return }
            
            switch state {
            case .initializing: displayAsBillboard()
            case let .detecting(hitTestResult, camera):
                if let planeAnchor = hitTestResult.anchor as? ARPlaneAnchor {
                    displayAsClosed(for: hitTestResult, planeAnchor: planeAnchor, camera: camera)
                    currentPlaneAnchor = planeAnchor
                }
                else {
                    displayAsOpen(for: hitTestResult, camera: camera)
                    currentPlaneAnchor = nil
                }
            }
        }
    }
    
    /// Indicates whether the segments of the focus square are disconnected.
    private var isOpen = false
    
    /// Indicates if the square is currently being animated.
    private var isAnimating = false
    
    /// Indicates if the square is currently changing its alignment.
    private var isChangingAlignment = false
    
    /// The focus square's current alignment.
    private var currentAlignment: ARPlaneAnchor.Alignment?
    
    /// The current plane anchor if the focus square is on a plane.
    private(set) var currentPlaneAnchor: ARPlaneAnchor?
    
    /// The focus square's most recent positions.
    private var recentFocusSquarePositions: [float3] = []
    
    /// The focus square's most recent alignments.
    private(set) var recentFocusSquareAlignments: [ARPlaneAnchor.Alignment] = []
    
    /// Previously visited plane anchors.
    private var anchorsOfVisitedPlanes: Set<ARAnchor> = []
    
    /// List of the segments in the focus sqaure
    private var segments: [FocusSquare.Segment] = []
}

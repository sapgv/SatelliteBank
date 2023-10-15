//
//  MyFloatingPanelLayout.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 14.10.2023.
//

import FloatingPanel

class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
        .tip: FloatingPanelLayoutAnchor(absoluteInset: 264, edge: .bottom, referenceGuide: .safeArea),
    ]
}

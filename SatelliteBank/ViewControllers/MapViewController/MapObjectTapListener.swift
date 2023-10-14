//
//  MapObjectTapListener.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 14.10.2023.
//

import YandexMapsMobile

final class MapObjectTapListener: NSObject, YMKMapObjectTapListener {

    private weak var controller: IMapViewController?
    
    init(controller: IMapViewController) {
        self.controller = controller
    }

    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        guard let placemark = mapObject as? YMKPlacemarkMapObject else { return false }
        self.controller?.didTap(placemark: placemark)
        return true
    }

}

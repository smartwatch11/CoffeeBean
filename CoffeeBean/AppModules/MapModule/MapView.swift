
import UIKit
import YandexMapsMobile
import SnapKit

final class MapView: UIViewController {
    lazy var mapView: YMKMapView = YBaseMapView().mapView
    
    var locations: [LocationModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPins()
        settings()
        zoomOnPin()
    }
    
    private func settings() {
        navigationItem.title = "Карта"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backToMainListView))
        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    private func zoomOnPin() {
        let point = YMKPoint(latitude: Double(locations[0].point.latitude) ?? 0, longitude: Double(locations[0].point.longitude) ?? 0)
        let viewPlacemark: YMKPlacemarkMapObject = mapView.mapWindow.map.mapObjects.addPlacemark(with: point)
        focusOnPlacemark(viewPlacemark)
    }
    
    @objc private func backToMainListView() {
        navigationController?.popViewController(animated: true)
    }
    
    private func focusOnPlacemark(_ placemark: YMKPlacemarkMapObject) {
        mapView.mapWindow.map.move(
              with: YMKCameraPosition(target: placemark.geometry, zoom: 10, azimuth: 0, tilt: 0),
              animation: YMKAnimation(type: YMKAnimationType.smooth, duration: 3)
        )
    }
    
    private func setPins() {
        for loc in locations {
            self.addPlacemarkOnMap(latitude: Double(loc.point.latitude) ?? 0, longitude: Double(loc.point.longitude) ?? 0, text: loc.name)
        }
    }
    
    func addPlacemarkOnMap(latitude: Double, longitude: Double, text: String) {
        let point = YMKPoint(latitude: latitude, longitude: longitude)
        let viewPlacemark: YMKPlacemarkMapObject = mapView.mapWindow.map.mapObjects.addPlacemark(with: point)
        
        viewPlacemark.setIconWith(
            UIImage(named: "mapPin")!,
            style: YMKIconStyle(
                anchor: CGPoint(x: 0.5, y: 0.5) as NSValue,
                rotationType: YMKRotationType.rotate.rawValue as NSNumber,
                zIndex: 0,
                flat: true,
                visible: true,
                scale: 1.0,
                tappableArea: nil
            )
        )
        viewPlacemark.setTextWithText(text, style: YMKTextStyle(size: 14, color: mainColor, outlineColor: nil, placement: .bottom, offset: 0, offsetFromIcon: true, textOptional: false))
    }
    
}

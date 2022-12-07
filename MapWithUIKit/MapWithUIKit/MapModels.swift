//
//  MapModels.swift
//  MapWithUIKit
//
//  Created by 内堀保貴 on 2022/12/07.
//

import MapKit
import SwiftUI

class LocationPin: NSObject, MKAnnotation {
   
    var title: String?
    var latitude: Double  // 緯度
    var longitude: Double // 経度
    // 座標
    var coordinate:CLLocationCoordinate2D {
       CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(title:String, latitude: Double ,longitude: Double) {
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
    }
}

struct UIMapView: UIViewRepresentable {

    let Manager = MapManager()

    func makeUIView(context: Self.Context) -> UIViewType {

        let mapView = Manager.mapViewObj

        let basePin1 = LocationPin(title: "東京駅",latitude:35.681464, longitude: 139.767052)
        let basePin2 = LocationPin(title: "東京スカイツリー", latitude: 35.709152712026265, longitude: 139.80771829999996)
        
        mapView.addAnnotation(basePin1)
        mapView.addAnnotation(basePin2)

        let basePlaceMark1 = MKPlacemark(coordinate: basePin1.coordinate)
        let basePlaceMark2 = MKPlacemark(coordinate: basePin2.coordinate)

        let directionRequest = MKDirections.Request() // リクエストインスタンス
        directionRequest.source = MKMapItem(placemark: basePlaceMark1) // 地点1登録
        directionRequest.destination = MKMapItem(placemark: basePlaceMark2) // 地点2登録
        directionRequest.transportType = MKDirectionsTransportType.automobile // 移動方法登録

        let directions = MKDirections(request: directionRequest)
            directions.calculate { (response, error) in
                // オプショナルバインディングで取り出す
                guard let directionResonse = response else {
                    if let error = error {
                        print("発生したエラー内容：\(error.localizedDescription)")
                    }
                    return // nilなら処理を終了
                }

                // ルートを取得
                let route = directionResonse.routes[0]

                // ビューにオーバーレイオブジェクトを追加
                mapView.addOverlay(route.polyline, level: .aboveRoads)

                // 2地点間がちょうど表示される縮尺を取得
                let rect = route.polyline.boundingMapRect

                var rectRegion = MKCoordinateRegion(rect)
                rectRegion.span.latitudeDelta = rectRegion.span.latitudeDelta * 1.2
                rectRegion.span.longitudeDelta = rectRegion.span.longitudeDelta * 1.2
                mapView.setRegion(rectRegion, animated: true)
            }

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Self.Context) {
        uiView.delegate = Manager
    }
} // class


class MapManager:NSObject, MKMapViewDelegate{
    var mapViewObj = MKMapView()
    override init() {
        super.init() // スーパクラスのイニシャライザを実行
        mapViewObj.delegate = self // 自身をデリゲートプロパティに設定
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
          let renderer = MKPolylineRenderer(overlay: overlay)
          renderer.strokeColor = UIColor.orange
          renderer.lineWidth = 3.0
          return renderer
      }
}

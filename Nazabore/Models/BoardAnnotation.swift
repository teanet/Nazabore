import MapKit

@objc public class BoardAnnotation: NSObject, MKAnnotation {

	public var coordinate: CLLocationCoordinate2D

	let marker: Marker
	init(marker: Marker) {
		self.marker = marker
		self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: self.marker.location.lat)!,
												 longitude: CLLocationDegrees(exactly: self.marker.location.lon)!)
	}

}



@objc public class MarkerFetcher: NSObject {

	let service: APIService
	@objc public override init() {
		self.service = APIService()
	}

	@objc public func get(c: CLLocation, cmp: @escaping (([BoardAnnotation]) -> Void)) {
		self.service.get(center: c) { (r) in
			switch r {

			case .success(let s):
				let markers = s.markers.map({ BoardAnnotation(marker: $0) })
				cmp(markers)
			case .error(_):
				break
			}
		}
	}


}


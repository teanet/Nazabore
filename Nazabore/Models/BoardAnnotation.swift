import MapKit

@objc public class BoardAnnotation: NSObject, MKAnnotation {

	public var coordinate: CLLocationCoordinate2D
	private let router: Router
	let marker: Marker
	init(marker: Marker, router: Router) {
		self.marker = marker
		self.router = router
		self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: self.marker.location.lat)!,
												 longitude: CLLocationDegrees(exactly: self.marker.location.lon)!)
	}

	@objc func select() {
		self.router.pushMarker(self.marker)
	}

}



@objc public class MarkerFetcher: NSObject {

	let service: APIService
	let router: Router
	internal init(service: APIService, router: Router) {
		self.service = service
		self.router = router
	}

	@objc public func get(c: CLLocation, cmp: @escaping (([BoardAnnotation]) -> Void)) {
		self.service.get(center: c) { (r) in
			switch r {
				case .success(let s):
					let markers = s.markers.map({ BoardAnnotation(marker: $0, router: self.router) })
					cmp(markers)
				case .error(_):
					break
			}
		}
	}

	@objc public func postMessage(location: CLLocation, emoji: String, message: String) {
		print(">>>>>\(message)")
		self.service.postMessage(location: location, emoji: emoji, message: message) { (r) in
			switch r {
				case .success(let marker):
					print(">>>>>\(marker)")
//					self.router.pushMarker(marker)
				case .error(let err):
					print(">>>>>\(err.localizedDescription)")
			}
		}

	}

}


@objc public class Router: NSObject {

	private let nc: UINavigationController
	init(nc: UINavigationController) {
		self.nc = nc
	}

	func pushMarker(_ marker: Any) {
		guard let marker = marker as? Marker else { return }

		ZaborVC

	}

}

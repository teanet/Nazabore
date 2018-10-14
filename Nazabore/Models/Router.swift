@objc public class Router: NSObject {

	private unowned let container: Container
	init(container: Container) {
		self.container = container
	}

	internal func pushMarker(_ marker: Marker) {
//		let vc = ZaborVC(marker: marker)
		#warning ("123")
//		self.container.rootVC.pushViewController(vc, animated: true)
	}

}

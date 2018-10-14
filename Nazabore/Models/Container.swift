@objc public class Container: NSObject {

	@objc public lazy var rootVC: UINavigationController = {
		let vc = NZBMapVC(router: self.router, markerFetcher: self.markerFetcher)
		return UINavigationController(rootViewController: vc)
	}()

	lazy var api = APIService()

	lazy var markerFetcher: MarkerFetcher = { [unowned self] in
		return MarkerFetcher(service: self.api, router: self.router)
	}()

	lazy var router: Router = { [unowned self] in
		return Router(container: self)
	}()

}

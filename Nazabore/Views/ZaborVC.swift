@objc internal class ZaborVC: NZBWriteVC {

	private let marker: Marker

	internal init(marker: Marker) {
		self.marker = marker
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

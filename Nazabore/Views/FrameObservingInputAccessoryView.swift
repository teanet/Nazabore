import UIKit

@objc public final class FrameObservingInputAccessoryView: UIView {

	var frameObservation: NSKeyValueObservation?
	var centerObservation: NSKeyValueObservation?
	@objc public var onFrameChanged: ((CGRect) -> Void)?
	convenience init() {
		self.init(frame: .zero)
		self.isUserInteractionEnabled = false
	}

	var inputAcesssorySuperviewFrame: CGRect {
		return self.superview!.frame
	}

	public override func willMove(toSuperview newSuperview: UIView?) {

		self.frameObservation = self.observe(\.frame) { [weak self] (view, value) in
			self?.frameChanged()
		}
		self.centerObservation = self.observe(\.center) { [weak self] (view, value) in
			self?.frameChanged()
		}

		super.willMove(toSuperview: newSuperview)
	}

	private func frameChanged() {
		if let frame = self.superview?.frame {
			self.onFrameChanged?(frame)
		}
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		self.frameChanged()
	}

}

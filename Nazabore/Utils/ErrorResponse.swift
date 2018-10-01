extension ErrorResponse: LocalizedError {

	var errorDescription: String? {
		#if DEBUG
		let finalMessage = "\(self.code): \(self.message)\n\(self.systemMessage)"
		return finalMessage
		#else
		return self.message
		#endif
	}

}

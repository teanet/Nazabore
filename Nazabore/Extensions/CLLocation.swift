import CoreLocation

extension CLLocation {

	var geoPoint: GeoPoint {
		var point = GeoPoint()
		point.lat = Double(self.coordinate.latitude)
		point.lon = Double(self.coordinate.longitude)
		return point
	}


}

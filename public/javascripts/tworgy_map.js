function TworgyMap(options) {
    DBC.require(options.mapDomID);

    var latlng = new google.maps.LatLng(-34.397, 150.644);

    if (google.loader.ClientLocation) {
      latlng = new google.maps.LatLng(google.loader.ClientLocation.latitude, google.loader.ClientLocation.longitude);
    }
    
    var myOptions = {
      zoom: 5,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    
    this.map = new google.maps.Map(jQuery(options.mapDomID)[0], myOptions);
    this.geocoder = new google.maps.Geocoder()
 
    this.findPosition = function(address, callback) {
        this.geocoder.geocode( { 'address': address}, function(results, status) {
            if (status == google.maps.GeocoderStatus.OK) {
                callback(results[0].geometry);
            } else {
            }
        });
    };
 
    this.findAddress = function(latLng, callback) {
        this.geocoder.geocode({latLng: latLng}, function(responses) {
            if (responses && responses.length > 0) {
              callback(responses[0].formatted_address);
            } else {
              callback('Cannot determine address at this location.');
            }
        });
    };
    this.zoomIn = function() {
        this.map.setZoom(this.map.getZoom() - 2);
    }
}
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
    this.findAddress = function() {
      var that = this;
      this.geocoder.geocode( { 'address': jQuery('#inputAddress').val()}, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
          var geometry = results[0].geometry;

          that.map.fitBounds(geometry.bounds);
        } else {
          alert("Geocode was not successful for the following reason: " + status);
        }
      });
    };
}
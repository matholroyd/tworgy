function TworgyFactory(params) {
    DBC.require(params.tworgyMap);
    DBC.require(params.data);
    
    var result = params.data;

    result.marker = new google.maps.Marker({
        position: new google.maps.LatLng(result.latitude, result.longitude),
        map: params.tworgyMap.map, 
        title: result.name,
        draggable:true
    });
    
    return result;
}
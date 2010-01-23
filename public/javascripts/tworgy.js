Tworgy = {
    callback:{}
    ,setupCallbacks:function(tworgy) {
        DBC.require(tworgy);
        DBC.require(tworgy.marker);
        
        if(Tworgy.callback.markerClick) {
            google.maps.event.addListener(tworgy.marker, 'click', function(event) {
                Tworgy.callback.markerClick(tworgy);
            });
        }

        if(Tworgy.callback.markerMouseOver) {
            google.maps.event.addListener(tworgy.marker, 'mouseover', function(event) {
                Tworgy.callback.markerMouseOver(tworgy);
            });
        }

        if(Tworgy.callback.markerMouseOut) {
            google.maps.event.addListener(tworgy.marker, 'mouseout', function(event) {
                Tworgy.callback.markerMouseOut(tworgy);
            });
        }
    }
}

function TworgyFactory(tworgy, tworgyMap) {
    DBC.require(tworgy);
    DBC.require(tworgyMap);
    
    tworgy.marker = new google.maps.Marker({
        position: new google.maps.LatLng(tworgy.latitude, tworgy.longitude)
        ,map: tworgyMap.map
        ,title: tworgy.name
        ,draggable:true
    });
    
   Tworgy.setupCallbacks(tworgy);
    
    return tworgy;
}
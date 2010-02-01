function tworgiesPath() {
    return '/tworgies.json';
}

function tworgiesCurrentUserOnlyPath() {
    return tworgiesPath() + '?current_user_only=true';
}

function tworgyPath(tworgy_id) {
  return '/tworgies/' + tworgy_id;
}


Tworgy = {
    setupCallbacks:function(tworgy) {
        DBC.require(this.callback);

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
};

function TworgyFactory(tworgy) {
    DBC.require(tworgy);

    tworgy.fullAccess = tworgy.user_id == Tworgy.currentUserID;
    
    tworgy.marker = new google.maps.Marker({
        position: new google.maps.LatLng(tworgy.latitude, tworgy.longitude)
        ,map: Tworgy.tworgyMap.map
        ,title: tworgy.name
        ,draggable:tworgy.fullAccess
    });
    
    Tworgy.setupCallbacks(tworgy);
    
    tworgy.update = function() {
        $.put(tworgyPath(this.id), {'tworgy[enabled]': this.enabled}, null, 'json');
        this.refresh();
        
    };
    tworgy.refresh = function(options) {
        var tworgyDom = Tworgy.callback.getTworgyDom(this.id);
        tworgyDom.replaceWith(Jaml.render('tworgy', this, options));
    };
    
    return tworgy;
}

Tworgy.EventHandler = {
    toggleEnabled:function(tworgyID, tworgyDom, element) {
        var tworgy = Tworgies.Cache.hash[tworgyID];
        
        tworgy.enabled = !tworgy.enabled;
        tworgy.update();
    }
    ,setActive:function(tworgyID, tworgyDom, element) {
        var tworgy = Tworgies.Cache.hash[tworgyID];
        tworgy.refresh({active:true});
    }
};
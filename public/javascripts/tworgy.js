function tworgiesPath() {
    return '/tworgies.json';
}

function tworgiesCurrentUserOnlyPath() {
    return tworgiesPath() + '?current_user_only=true';
}

function tworgyPath(tworgy_id) {
  return '/tworgies/' + tworgy_id;
}

function Tworgy(data) {
    DBC.require(data);
    DBC.require(Tworgy.callback);
    DBC.require(Tworgy.tworgyMap);
    
    for(var d in data) {
        if (data.hasOwnProperty(d)) {
            this[d] = data[d];
        }
    }

    var that = this;
    this.fullAccess = this.user_id == Tworgy.currentUserID;
    this.marker = new google.maps.Marker({
        position: new google.maps.LatLng(this.latitude, this.longitude)
        ,map: Tworgy.tworgyMap.map
        ,title: this.name
        ,draggable:this.fullAccess
    });
    
    if(Tworgy.callback.markerClick) {
        google.maps.event.addListener(this.marker, 'click', function(event) {
            Tworgy.callback.markerClick(that);
        });
    }

    if(Tworgy.callback.markerMouseOver) {
        google.maps.event.addListener(this.marker, 'mouseover', function(event) {
            Tworgy.callback.markerMouseOver(that);
        });
    }

    if(Tworgy.callback.markerMouseOut) {
        google.maps.event.addListener(this.marker, 'mouseout', function(event) {
            Tworgy.callback.markerMouseOut(that);
        });
    }
    
    this.update = function() {
        $.put(tworgyPath(this.id), {'tworgy[enabled]': this.enabled}, null, 'json');
        this.refresh();
    };

    this.refresh = function(options) {
        var tworgyDom = Tworgy.callback.getTworgyDom(this.id);
        tworgyDom.replaceWith(Jaml.render('tworgy', this, options));
    };
};

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
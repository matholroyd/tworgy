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
    this.visible = true;
    this.marker = new google.maps.Marker({
        map: Tworgy.tworgyMap.map
        ,title: this.name
    });
    
    function setupCallbacks() {
        google.maps.event.addListener(that.marker, 'click', function(event) {
            that.onClick();
        });
        
        google.maps.event.addListener(that.marker, 'dblclick', function(event) {
            that.onDblClick();
        });

        google.maps.event.addListener(that.marker, 'mouseover', function(event) {
            if(Tworgy.callback.markerMouseOver) {
                Tworgy.callback.markerMouseOver(that);
            }
        });

        google.maps.event.addListener(that.marker, 'mouseout', function(event) {
            if(Tworgy.callback.markerMouseOut) {
                Tworgy.callback.markerMouseOut(that);
            }
        });
        
        google.maps.event.addListener(that.marker, 'dragstart', function() {
        });

        google.maps.event.addListener(that.marker, 'dragend', function() {
            that.latitude = that.marker.getPosition().lat();
            that.longitude = that.marker.getPosition().lng();
            that.update();
            that.onClick();
        });
    }
    
    setupCallbacks();
    this.refreshMarker();
};

Tworgy.prototype = {
    update:function() {
        jQuery.put(tworgyPath(this.id), {
            'tworgy[enabled]': this.enabled
            ,'tworgy[longitude]':this.marker.getPosition().lng()
            ,'tworgy[latitude]':this.marker.getPosition().lat()
        }, null, 'json');
        this.refresh();
    }
    ,getPosition:function() {
        return new google.maps.LatLng(this.latitude, this.longitude);
    }
    ,refresh:function(options) {
        this.checkLatLng();

        var tworgyDom = Tworgy.callback.getTworgyDom(this.id);
        tworgyDom.replaceWith(Jaml.render('tworgy', this, options));

        this.refreshMarker();
    }
    ,refreshMarker:function() {
        this.marker.setVisible(this.visible && this.enabled);
        this.marker.setDraggable(this.fullAccess);
        this.marker.setPosition(this.getPosition());
    }
    ,checkLatLng:function() {
        if((this.latitude == null || this.longitude == null) && (this.enabled && this.visible)) {
            var latlng = Tworgy.tworgyMap.map.getCenter();
            this.latitude = latlng.lat();
            this.longitude = latlng.lng();
        }
    }
    ,onClick:function() {
        Tworgy.callback.beforeClick(this);
        Tworgies.Cache.activeTworgy = this;
    }
    ,onDblClick:function() {
        Tworgy.tworgyMap.map.setZoom(15);
        Tworgy.tworgyMap.map.panTo(this.getPosition());
    }
    ,enabledToggle:function() {
        this.enabled = !this.enabled;
        this.update();
    }
    ,isActive:function() {
        return this == Tworgies.Cache.activeTworgy;
    }
    ,moveTo:function(latLng) {
        this.latitude = latLng.lat();
        this.longitude = latLng.lng();
        this.refreshMarker();
        this.update();
    }
    ,getMembers:function(callback) {
        jQuery.getJSON(this.url, function(data) { 
            that.load(data);
        });
        
    }
    ,getSubscribers:function(callback) {
        
    }
}
 
function TworgyManager(options) {
    DBC.require(options.tworgyMap);
    
    this.tworgyMap = options.tworgyMap;
    this.allTworgies = [];
    this.userTworgies = [];
    this.loadAllTworgies = function() {
        var that = this;
        jQuery.getJSON('/tworgies.json', function(data) { 
            that.allTworgies = data;
            that.load(data);
        });
    };
    this.loadUserTworgies = function(user_id) {
        var that = this;
        jQuery.getJSON('/tworgies.json?current_user_only=true', function(data) { 
            that.userTworgies = data;
            that.load(data);
        });
    };
    this.load = function(data) {
        for(var i = 0; i < data.length; i++) {
            data[i].marker = new google.maps.Marker({
                position: new google.maps.LatLng(data[i].latitude, data[i].longitude),
                map: this.tworgyMap.map, 
                title: 'Drag marker to where the Tworgy is happening',
                draggable:true
            });
        }
        
        if(this.callback && this.callback.onLoad) {
            this.callback.onLoad(data);
        }
    };
    this.callback = options.callback;
}

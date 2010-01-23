function Tworgies(options) {
    DBC.require(this.tworgyMap);
    DBC.require(this.callback);

    DBC.require(options.url);
    DBC.require(options.domID);

    this.url = options.url;
    this.domID = options.domID;

    var that = this;
    Tworgy.callback = this.callback;

    this.process = function(tworgies) {
        this.hash = {};
        for(var i = 0; i < tworgies.length; i++) {
            tworgies[i] = this.setupTworgy(tworgies[i]);
            this.hash[tworgies[i].id] = tworgies[i];
        }
        
        return tworgies;
    }
    this.setupTworgy = function(tworgy) {
        var result = Tworgies.Cache.add(tworgy, this.tworgyMap);
        
        if(this.callback.tworgyRenderer) {
            $(this.domID).append(this.callback.tworgyRenderer(result));
        }
        
        return result;
    }
    this.setVisible = function(visible) {
        var tworgy;
        for(var i = 0; i < Tworgies.Cache.array.length; i++) {
            tworgy = Tworgies.Cache.array[i];
            if(this.hash[tworgy.id] != undefined) {
                tworgy.marker.setVisible(visible);
            } else {
                tworgy.marker.setVisible(!visible);
            }
        }
    }
 
    jQuery.getJSON(this.url, function(data) { 
        that.data = that.process(data);
    });
    
}

Tworgies.Cache = {
    array:[]
    ,hash:{}
    ,callback:{}
    ,add:function(tworgy, tworgyMap) {
        var that = this;
        var result = this.hash[tworgy.id];
        
        if(result == undefined) {
            result = TworgyFactory(tworgy, tworgyMap);

            this.hash[result.id] = result;
            this.array.push(result);
        }
        
        return result;
    }
    ,contains:function(tworgy) {
        return this.hash[tworgy.id] != undefined;
    }
};

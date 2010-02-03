function Tworgies(options) {
    DBC.require(options.url);
    DBC.require(options.domID);

    this.url = options.url;
    this.domID = options.domID;

    var that = this;
    this.hash = {};
    this.data = [];

    this.load = function(tworgies) {
        this.hash = {};
        this.data = [];

        for(var i = 0; i < tworgies.length; i++) {
            tworgies[i] = this.setupTworgy(tworgies[i]);
            this.hash[tworgies[i].id] = tworgies[i];
        }
        
        this.data = tworgies;
    }
    this.setupTworgy = function(tworgyData) {
        var result = Tworgies.Cache.add(tworgyData);
        
        if(Tworgy.callback.tworgyRenderer) {
            $(this.domID).append(Tworgy.callback.tworgyRenderer(result));
        }
        
        return result;
    }
    this.setVisible = function(visible) {
        var tworgy;
        for(var i = 0; i < Tworgies.Cache.array.length; i++) {
            tworgy = Tworgies.Cache.array[i];
            if(this.hash[tworgy.id] != undefined) {
                tworgy.visible = visible;
            } else {
                tworgy.visible = !visible;
            }
            tworgy.refresh();
        }
    }
 
    jQuery.getJSON(this.url, function(data) { 
        that.load(data);
    });
    
}

Tworgies.Cache = {
    array:[]
    ,hash:{}
    ,callback:{}
    ,add:function(tworgyData) {
        var that = this;
        var result = this.hash[tworgyData.id];
        
        if(result == undefined) {
            result = new Tworgy(tworgyData);

            this.hash[result.id] = result;
            this.array.push(result);
        }
        
        return result;
    }
    ,contains:function(tworgy) {
        return this.hash[tworgy.id] != undefined;
    }
};

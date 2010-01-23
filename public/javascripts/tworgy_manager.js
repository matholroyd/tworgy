
function TworgyManager(options) {
    DBC.require(options.tworgyMap);
    DBC.require(options.allTworgiesDomID);
    DBC.require(options.userTworgiesDomID);

    this.tworgyMap = options.tworgyMap;
    this.allTworgiesDomID = options.allTworgiesDomID;
    this.userTworgiesDomID = options.userTworgiesDomID;

    this.callback = options.callback;
    this.allTworgies = [];
    this.userTworgies = [];
    this.loadAllTworgies = function() {
        var that = this;
        jQuery.getJSON('/tworgies.json', function(data) { 
            that.allTworgies = that.process(data, that.allTworgiesDomID);
        });
    };
    this.loadUserTworgies = function(user_id) {
        var that = this;
        jQuery.getJSON('/tworgies.json?current_user_only=true', function(data) { 
            that.userTworgies = that.process(data, that.userTworgiesDomID);
        });
    };
    this.showTworgies = function(options) {
        this.setVisible(this.allTworgies, !options.userOnly);
        this.setVisible(this.userTworgies, options.userOnly);
    }
    this.setVisible = function(tworgies, visible) {
        for(var i = 0; i < tworgies.length; i++) {
            tworgies[i].marker.setVisible(visible);
        }
    }
    this.process = function(tworgies, domID) {
        for(var i = 0; i < tworgies.length; i++) {
            tworgies[i] = TworgyFactory({data:tworgies[i], tworgyMap:this.tworgyMap});

            if(this.callback && this.callback.tworgyRenderer) {
                $(domID).append(this.callback.tworgyRenderer(tworgies[i]));
            }
        }
        
        return tworgies;
    }
}

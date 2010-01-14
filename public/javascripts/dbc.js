DBC = {
    errorMsg:function(type) {
        var c = arguments.callee.caller;
        throw 'DBC ' + type + ' Error: in ' + c.getName() + '\n' + c.trace();
    }
    ,require:function(check) {
        if(!check) {
            this.errorMsg('Require');
        } 
    }
    ,assert:function(check) {
        if(!check) {
            this.errorMsg('Assert');
        } 
    }
    ,ensure:function(check) {
        if(!check) {
            this.errorMsg('Ensure');
        } 
    }
};


Function.prototype.trace = function()
{
    var trace = [];
    var current = this;
    while(current)
    {
        trace.push(current.signature());
        current = current.caller;
    }
    return trace;
}
Function.prototype.signature = function()
{
    var signature = {
        name: this.getName(),
        params: [],
        toString: function()
        {
            var params = this.params.length > 0 ?
                "'" + this.params.join("', '") + "'" : "";
            return this.name + "(" + params + ")"
        }
    };
    if(this.arguments)
    {
        for(var x=0; x<this .arguments.length; x++) {
            signature.params.push(this.arguments[x]);
        }
    }
    return signature;
}
Function.prototype.getName = function()
{
    if(this.name) {
        return this.name;
    }
    var definition = this.toString().split("\n")[0];
    var exp = /^function ([^\s(]+).+/;
    if(exp.test(definition)) {
        return definition.split("\n")[0].replace(exp, "$1") || "anonymous";
    }
    return "anonymous";
}
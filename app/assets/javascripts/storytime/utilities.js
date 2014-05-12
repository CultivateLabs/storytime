Storytime.Utilities = {
  controllerFromString: function(str){
    var base = window;
    var components = str.split("::");
    for(var i=0; i<components.length; i++){
      var component = components[i];
      if(base[component]){
        if(i == components.length - 1){
          return base[component];
        }
        else{
          base = base[component];
        }
      }
      else{
        return null;
      }
      
    }
  }
}
var tworgyMap;
var userTworgies;
var allTworgies;

Jaml.register('tworgy', function(tworgy, options) {
    var klass = 'tworgy';
    
    if(options === undefined) {
        options = {};
    } else {
    }
    
    if(tworgy.fullAccess) {
        klass += ' fullAccess';
    } else {
        klass += ' limitedAccess';
    }
    
    if(tworgy.enabled) {
        klass += ' enabled';
    }
    
    if(tworgy.isActive()) {
        klass += ' active';
    }

    if(tworgy.enabled) {
        li({'class':klass, ref:tworgy.id}
            ,input({type:'checkbox', value:tworgy.id, checked:true})
            ,span(tworgy.name)
        );
    } else {
        li({'class':klass, ref:tworgy.id}
            ,input({type:'checkbox', value:tworgy.id})
            ,span(tworgy.name)
        );
    }
});


$(document).ready(function() {

    tworgyMap = new TworgyMap({
        mapDomID:"#map_canvas"
    });
    
    Tworgy.tworgyMap = tworgyMap;
    Tworgy.currentUserID = currentUserID;
    Tworgy.callback = { 
        tworgyRenderer: tworgyRenderer
        ,beforeClick: beforeClick
        ,markerMouseOver: markerMouseOver
        ,markerMouseOut: markerMouseOut
        ,getTworgyDom:getTworgyDom
    }
    
    allTworgies = new Tworgies({
        url:tworgiesPath()
        ,domID: '#allTworgies ul.tworgies'
    });
    
    userTworgies = new Tworgies({
        url:tworgiesCurrentUserOnlyPath()   
        ,domID: '#userTworgies ul.tworgies'
    });

    $('#tabs').tabs({
        selected:0
        ,select: function(event, ui) { 
            setVisibleTworgies({userOnly:ui.tab.hash == '#userTworgies'});
        }
    });
    
    $("li.tworgy input").live('click', function() {
        tworgyEvent(this, Tworgy.EventHandler.toggleEnabled);
    });

    $("li.tworgy span").live('click', function() {
        var tworgy = findTworgy(this);
        tworgy.onClick();
    });
    
    $('#findAddress').click(function() {
        var address = $('#inputAddress').val();
        tworgyMap.findPosition(address, function(geometry) {
            tworgyMap.map.fitBounds(geometry.viewport);
        });
    });
    $('#moveTworgyToAddress').click(function() {
        var address = $('#inputAddress').val();
        tworgyMap.findPosition(address, function(geometry) {
            tworgyMap.map.fitBounds(geometry.viewport);
            Tworgies.Cache.moveActiveTo(geometry.location);
        });
    });
    
});

function getTworgyDom(tworgyID) {
    return $('li.tworgy[ref="' + tworgyID + '"]');
}

function findTworgy(element) {
    var li = $(element).parent();
    var tworgyID = li.attr('ref');
    return Tworgies.Cache.find(tworgyID);
}

function tworgyEvent(element, eventHandler) {
    var li = $(element).parent();
    var tworgyID = li.attr('ref');
    
    eventHandler(tworgyID, li, element);
}

function setVisibleTworgies(options) {
    if(options.userOnly) {
        userTworgies.setVisible(true);
    } else {
        allTworgies.setVisible(true);
    }
}

function beforeClick(tworgy) {
    tworgyMap.map.panTo(tworgy.marker.getPosition());
    $('.tworgy').removeClass('active');
    var address = tworgyMap.findAddress(tworgy.marker.getPosition(), function(address) {
        $('#inputAddress').val(address);
    });
}

function markerMouseOver(tworgy) {
    $('.tworgy').removeClass('hover');
    $('.tworgy[ref="' + tworgy.id + '"]').addClass('hover');
}

function markerMouseOut(tworgy) {
    $('.tworgy').removeClass('hover');
}

function tworgyRenderer(tworgy) {
    return Jaml.render('tworgy', tworgy);
}



/////////////////////


// function setupMap() {  
//   var latlng = new google.maps.LatLng(-34.397, 150.644);
//   if (google.loader.ClientLocation) {
//     latlng = new google.maps.LatLng(google.loader.ClientLocation.latitude, google.loader.ClientLocation.longitude);
//   }
// 
//   var myOptions = {
//     zoom: 5,
//     center: latlng,
//     mapTypeId: google.maps.MapTypeId.ROADMAP
//   };
//   map = new google.maps.Map($("#map_canvas:first")[0], myOptions);
// }

// function findAddress() {
//   geocoder.geocode( { 'address': $('#inputAddress').val()}, function(results, status) {
//     if (status == google.maps.GeocoderStatus.OK) {
//       var geometry = results[0].geometry;
// 
//       if(marker) {
//         updateTworgyLatLng(marker_tworgy_id, geometry.location);
//         // marker.setPosition(geometry.location);
//         // map.panTo(geometry.location);
//       }
// 
//       map.fitBounds(geometry.bounds);
//     } else {
//       alert("Geocode was not successful for the following reason: " + status);
//     }
//   });
// }


// function setupDraggableMarker(tworgy_id) {  
//   var latlng = null;
//   
//   var tworgy_ll = tworgy_latlngs[tworgy_id];
//   var lat = tworgy_ll.lat;
//   var lng = tworgy_ll.lng;
//   
//   if(lat && lng) {
//     latlng = new google.maps.LatLng(lat, lng);
//   } else {
//     latlng = map.getCenter();
//   }
//   
//   addMarker(tworgy_id, latlng);
// }
// 
// function addMarker(tworgy_id, pos) {
//   if(marker) {
//     clearMarker();
//   }
// 
//   marker_tworgy_id = tworgy_id;
//   marker = new google.maps.Marker({
//     position: pos,
//     map: map, 
//     title: 'Drag marker to where the Tworgy is happening',
//     draggable:true
//   });
// 
//   geocodePosition(marker.getPosition());
//   // if(map.getZoom() > 15) {
//   //   map.setZoom(15);
//   // }
//   
//   var zoom = map.getZoom();
//   map.panTo(pos);
//   map.setZoom(zoom);
//    
//    google.maps.event.addListener(marker, 'dragend', function() {
//      updateTworgyLatLng(tworgy_id, marker.getPosition());
//      geocodePosition(marker.getPosition());
//    });
// }
// 
// function clearMarker() {
//   if(marker) {
//     marker.setMap(null);
//   }
// }

// function geocodePosition(pos) {
//   geocoder.geocode({latLng: pos}, function(responses) {
//     if (responses && responses.length > 0) {
//       updateMarkerAddress(responses[0].formatted_address);
//     } else {
//       updateMarkerAddress('Cannot determine address at this location.');
//     }
//   });
// }

// function updateMarkerAddress(str) {
//   $('#inputAddress').val(str);
// }

// $(document).ready(function() {
// 
//   TworgyMap.setup();
//   $('#findAddress').click(function() {
//     TworgyMap.findAddress();
//   });
// 
//   TworgyManager.loadAllTworgies();
//   for(var i = 0; i < TworgyManager.allTworgies.length; i++) {
//       
//   }

  // $('a#addList').click(function() {
  //   $('#fieldsAddList').toggle();
  // });


  // $('#finishedAddingMarker').click(function() {
  // 
  // });

  // $('#clearMarker').click(function() {
  //   clearMarker();
  // });
  // 

  // var tabs = $("#tabs").tabs({ selected: 0 });
  // 
  // $('#dialogSetMarker').dialog({
  //   autoOpen:false,
  //   modal:true,
  //   buttons: { 
  //     "Cancel": function() { $(this).dialog("close"); },
  //     "Create Tworgy":function() { $(this).dialog("close"); }
  //   }
  // });
  // 
  // $("ul#location_list li span").click(function() {
  //   $("ul#location_list li").removeClass('active');
  //   
  //   var li = $(this).parent();
  //   var tworgy_id = li.attr('ref');
  // 
  //   li.addClass('active');
  //   setupDraggableMarker(tworgy_id);
  // });
  // $("ul#location_list li input").click(function() {
  //   toggleCheckBox(this, true);
  // });
  // 
  // $("ul#location_list li input").each(function() {
  //    toggleCheckBox(this, false);
  // });
// });   



// 
// function toggleCheckBox(checkbox, update) {
//   var enabled = checkbox.checked;
//   var li = $(checkbox).parent();
//   
//   li.toggleClass("enabled", enabled);    
//   
//   if(update) {
//     var tworgy_id = li.attr('ref');
//     updateTworgy(tworgy_id, {'tworgy[enabled]': enabled});
//   }
// }

// function updateTworgyLatLng(tworgy_id, pos) {
//   updateTworgy(tworgy_id, {
//     'tworgy[latitude]': pos.lat(), 
//     'tworgy[longitude]': pos.lng()}
//   );
//   marker.setPosition(pos);
//   map.panTo(pos);
//   tworgy_latlngs[tworgy_id] = {lat : pos.lat(), lng : pos.lng()};
// }
// 
// function updateTworgy(tworgy_id, data) {
//   $.put(tworgyPath(tworgy_id), data, null, 'json');
// }

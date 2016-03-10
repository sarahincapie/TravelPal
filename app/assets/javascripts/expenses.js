if ($("#expense_chart").length > 0) {
  var chart = c3.generate({
      data: {
          columns: [
              ['Nightlife', $('#nightlife').data('nightlife')],
              ['Accommodation', $('#accommodation').data('accommodation')],
              ['Food', $('#food').data('food')],
              ['Transportation', $('#transportation').data('transportation')],
              ['EntertainmentAttractions', $('#entertainmentattractions').data('entertainmentattractions')],
              ['Culture', $('#culture').data('culture')],
              ['Shopping', $('#shopping').data('shopping')],
              // ['SportsOutdoor', $('#sportsoutdoor').data('sportsoutdoor')],
              // ['NatureEnvironment', $('#natureenvironment').data('natureenvironment')],
              // ['Business', $('#business').data('business')],
              // ['HealthFitness', $('#healthfitness').data('healthfitness')],
              // ['Miscellaneous', $('#miscellaneous').data('miscellaneous')],
          ],
          type : 'donut'
      },
      donut: {

      },
        color: {
          pattern: ['#1f77b4', '#8EBAA8', '#B9CDCA', '#F2DCCB', '#FDAC8A', '#98df8a', '#E38251']
      },
       transition: {
            duration: 4000
          }

  });

  setTimeout(function() {
          chart.load({
          });
      }, 500);

  $("#expense_chart").append(chart.element);
}


// end of first chart
var bar_arr = [];
$(".week_chart_data").each(function (index, value) {
    var arr = [$(value).data('location'),$(value).data('cost')];
    bar_arr.push(arr);
});



if (("#week_chart").length > 0) {
  var chart2 = c3.generate({
      data: {
          columns: bar_arr,
          type : 'bar'
      },
      bar: {
          title: "My weekly expenses",
       },

      color: {
          pattern: ['#1f77b4', '#8EBAA8', '#B9CDCA', '#F2DCCB', '#FDAC8A', '#98df8a', '#E38251']
      },
        transition: {
            duration: 4000
          }

  });

  setTimeout(function() {
    chart2.load({
        data: {
          columns: bar_arr
        }
    });
  }, 500);


  $("#week_chart").append(chart2.element);
}
// end of 2nd chart

var bar_array = [];
$(".pink_chart_data").each(function (index, value) {
    var arr = [$(value).data('date'),$(value).data('cost')];
    bar_array.push(arr);
});

if ($('#pink_chart').length > 0) {
  var chart3 = c3.generate({
      data: {
          columns: bar_array,
          type : 'bar'
      },
       zoom: {
          enabled: true
      },
      color: {
          pattern: ['#1f77b4', '#8EBAA8', '#B9CDCA', '#F2DCCB', '#FDAC8A', '#98df8a', '#E38251']
      },
          transition: {
            duration: 4000
          }
  });

  setTimeout(function() {
          chart3.load({
              data: {
          columns: bar_array
      }

          });

      }, 500);


  $("#pink_chart").append(chart3.element);
}


// end of third chart

//MAP START


$(document).ready(function() { // THIS GETS THE DOCUMENT READY


//var mymap = L.map('mapid').setView([25.5, -80.5], 13);


var mymap = L.tileLayer('https://api.tiles.mapbox.com/v4/saral85.pbc8hh2h/{z}/{x}/{y}.png?access_token=pk.eyJ1Ijoic2FyYWw4NSIsImEiOiJjaWxoMW52ZDcyY2F5dm5tYzZwYjFyd2E2In0.VK4Xxad4P0p1Uv4h19eV3g', {
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
    maxZoom: 18,
    id: 'saral85.pbc8hh2h',
    accessToken: 'pk.eyJ1Ijoic2FyYWw4NSIsImEiOiJjaWxoMW52ZDcyY2F5dm5tYzZwYjFyd2E2In0.VK4Xxad4P0p1Uv4h19eV3g'
});//.addTo(mymap);



if ($('#mapid').length > 0) {
  $.getJSON("./expenses.json", function(data) {
      var geojson = L.geoJson(data, {
        onEachFeature: function (feature, layer) {
          layer.bindPopup(feature.properties.name);
        }
      });

      var map = L.map('mapid').fitBounds(geojson.getBounds());
        mymap.addTo(map);
        geojson.addTo(map);
  });
}


//L.geoJson(geojsonFeature).addTo(map);

// $.getJSON('http://a.tiles.mapbox.com/v4/MAPID/features.json?access_token=TOKEN', function (data) {
//       // Assuming the variable map contains your mapinstance
//       var geojson = L.geoJson(data).addTo(map);
//       map.fitBounds(geojson.getBounds());

// // // // THIS IS ADDED FOR GEO JSON

// mylayer.on('mapid', function(e) {
//     var marker, popupContent, properties;
//     marker = e.layer;
//     properties = marker.feature.properties;
//     popupContent = '<div class="popup"><h3><a href="/markers/' + properties.id + '" target="marker"></a></h3></div>';
//     return marker.bindPopup(popupContent, {
//       closeButton: false,
//       minWidth: 300
//     });
//   });


// // THIS IS END FOR ADDED FOT GEO JSON

// AJAX

// $.ajax({
// dataType: 'text',
// url: '/expenses.json',
// success: function(data) {
// var geojson;
// geojson = $.parseJSON(data);
// return mylayer.setGeoJSON(geojson);
//     }
//   });

  });


// AJAX END



//var marker = L.marker([25.5, -80.5]).addTo(mymap);


// MAP END




// progress start




// progress end


//GEOJSON


// GEOJSON END

//  $(document).ready(function() {

//   L.mapbox.accessToken='pk.eyJ1Ijoic2FyYWw4NSIsImEiOiJjaWxobGxzNG8yajZhdmVtMDdmMjEwZGo5In0.VRJjrN4lCTBaLdPV4QhUBw'
//   var map= L.mapbox('map', 'saral85.pbc8hh2h').setView([39.606810, -116.929677], 7);



//   var myLayer = L.mapbox.featureLayer().addTo(map);
//   myLayer.on('layeradd', function(e) {
//     var marker, popupContent, properties;
//     marker = e.layer;
//     properties = marker.feature.properties;
//     popupContent = '<div class="popup"><h3><a href="/markers/' + properties.id + '" target="marker">' + properties.name + '</a></h3><p class="popup-num">Marker No. ' + properties.number + '</p><p>' + properties.description + '</p></div>';
//     return marker.bindPopup(popupContent, {
//       closeButton: false,
//       minWidth: 300
//     });
//   });

//   $.ajax({
//     dataType: 'text',
//     url: '/expenses.json',
//     success: function(data) {
//       var geojson;
//       geojson = $.parseJSON(data);
//       return myLayer.setGeoJSON(geojson);
//     }
//   });
// });

// sencond progress bar

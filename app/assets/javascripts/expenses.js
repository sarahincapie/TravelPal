
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
        title: "I'm spending my money on",
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

// end of first chart
var bar_arr = []; 
$(".week_chart_data").each(function (index, value) {
    var arr = [$(value).data('location'),$(value).data('cost')];
    bar_arr.push(arr);
});


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

// end of 2nd chart 

var bar_array = []; 
$(".pink_chart_data").each(function (index, value) {
    var arr = [$(value).data('date'),$(value).data('cost')];
    bar_array.push(arr);
});

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


// end of third chart

var mymap = L.map('mapid').setView([51.505, -0.09], 13);

// var chart3 = c3.generate({
//     data: {
//         columns: bar_arr,
           
//         types: {
//             data1: 'area',
//             data2: 'area-spline'
//         },
//          colors: {
//            data1: 'hotpink',
//            data2: 'pink'
//          }
//     }
// });



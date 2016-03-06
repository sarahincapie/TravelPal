
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
    }
});

var bar_arr = []; 
$(".week_chart_data").each(function (index, value) {
    var arr = [$(value).data('location'),$(value).data('cost')];
    bar_arr.push(arr);
});
$("#expense_chart").append(chart.element);

var chart2 = c3.generate({
    data: {
        columns: bar_arr,
        type : 'bar'
    },
    bar: {
        title: "My weekly expenses",
    }
});

$("#week_chart").append(chart2.element);


var chart3 = c3.generate({
    bindto: '#chart4',
    data: {
        columns: [
            ['data1', 300, 350, 300, 0, 0, 0],
            ['data2', 130, 100, 140, 200, 150, 50]
        ],
        types: {
            data1: 'area',
            data2: 'area-spline'
        },
         colors: {
           data1: 'hotpink',
           data2: 'pink'
         }
    }
});

$("#pink_chart").append(chart3.element);



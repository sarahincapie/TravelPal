
var chart = c3.generate({
    data: {
        columns: [
            ['Nightlife', $('#nightlife').data('nightlife')],
            ['Accommodation', $('#accommodation').data('accommodation')],
            ['Food', $('#food').data('food')],
            ['Attraction', $('#attraction').data('attraction')],
        ],
        type : 'donut'
    },
    donut: {
        title: "I'm spending my money on",
    }
});

$("#expense_chart").append(chart.element);

var chart2 = c3.generate({
    data: {
        columns: [
            ['monday', 200],
            ['tuesday', 50],
            ['wednesday', 60],
            ['thursday', 80],
            ['friday', 70],
            ['Saturday', 80],
            ['Sunday', 140],
        ],
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



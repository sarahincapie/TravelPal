
var chart = c3.generate({
    data: {
        columns: [
            ['Nightlife', 20],
            ['Accomodation', 20],
            ['Food', 20],
            ['Attraction', 40],
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




var circle2 = new ProgressBar.Circle('.progressbar2', {
    color: '#E38251',
    trailColor: "#F2DCCB",
    textColor: '#F2DCCB',
    strokeWidth: 5,
    trailWidth: 3,
    width: '50%',
    duration: 6500,
    text: {
        value: "$"

    },
    step: function(state, bar) {
        bar.setText( ' $' +(bar.value() * 100).toFixed(0)+ ' Spent');
    }
});

circle2.animate(1, function() {
    circle2.animate(0.44);
});


var circle = new ProgressBar.Circle('.progressbar', {
    color: '#B9CDCA',
    trailColor: "#1f77b4",
    textColor: '#1f77b4',
    strokeWidth: 5,
    trailWidth: 3,
    width: '50%',
    duration: 6500,
    //text: (bar.value() * 100).toFixed(0),
    step: function(state, bar) {
        bar.setText(' $' +(bar.value() * 100).toFixed(0) + ' Remaining');
    }
});

circle.animate(1, function() {
    circle.animate(0.56);
});
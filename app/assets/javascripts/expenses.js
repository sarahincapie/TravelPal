var chart = c3.generate({
    data: {
        columns: [
            ['Lulu', 50],
            ['Olaf', 50],
        ],
        type : 'donut'
    },
    donut: {
        title: "Dogs love:",
    }
});

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

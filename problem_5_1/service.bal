import ballerina/graphql;

// Don't change the port number
service /graphql on new graphql:Listener(9090) {

    // Write your answer here. You must change the input and
    // the output of the below signature along with the logic.

    

    


    resource function get sleepSummary() returns string {
        json[] array = [
        {
            "date": "2022-03-20",
            "duration": 1728000,
            "levels": {
                "deep": 1140000,
                "wake": 48000
            }
        },
        {
            "date": "2022-03-15",
            "duration": 1684800,
            "levels": {
                "deep": 1254000,
                "wake": 10800
            }
        },
        {
            "date": "2022-03-10",
            "duration": 1684800,
            "levels": {
                "deep": 1200000,
                "wake": 4800
            }
        },
        {
            "date": "2022-02-10",
            "duration": 1404000,
            "levels": {
                "deep": 1200000,
                "wake": 24000
            }
        },
        {
            "date": "2022-02-03",
            "duration": 1620000,
            "levels": {
                "deep": 1200000,
                "wake": 0
            }
        },
        {
            "date": "2022-01-07",
            "duration": 1512000,
            "levels": {
                "deep": 1200000,
                "wake": 12000
            }
        },
        {
            "date": "2022-01-01",
            "duration": 1728000,
            "levels": {
                "deep": 1200000,
                "wake": 48000
            }
        }
    ];

    //convert json array to string 
    
    string str = array.toString();

    return str;
    }
}

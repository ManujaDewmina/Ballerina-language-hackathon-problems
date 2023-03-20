import ballerina/http;

function findTheGift(string userID, string 'from, string to) returns Gift|error {

    worker A returns int|error{
        final http:Client fifitEp = check new("http://localhost:9091/activities",retryConfig = { interval: 3,count: 3},timeout = 10);

        string u = "/steps/user/"+userID+"/from/"+'from+"/to/"+to;

        http:Response response = check fifitEp->get(u);

        if (response.statusCode == 500) {
            response = check fifitEp->get(u);
        }

        // get json payload from the response
        json payload = check response.getJsonPayload();

        //store the steps in Activities record
        Activities activities = check payload.cloneWithType(Activities);
        int totalSteps = 0;
        foreach var item in activities.activities\-steps {
            totalSteps = totalSteps + item.value;
        }

        return totalSteps;
    }



    worker B returns int|error{
        http:FailoverClient insureEveryoneEp = check new ({
            timeout: 10,
            failoverCodes: [500],
            interval: 3,
            // Define a set of HTTP Clients that are targeted for failover.
            targets: [
                {url: "http://localhost:9092/insurance1"},
                {url: "http://localhost:9092/insurance2"}
            ]
        });

        http:Response response2 = check insureEveryoneEp->get("/user/"+userID);
    
        json payload2 = check response2.getJsonPayload();

        int age = check payload2.user.age;

        return age;
    }

    int totalSteps = check wait A;
    int age = check wait B;

    int score_final = totalSteps/((100-age)/10);

    if (score_final < SILVER_BAR) {
        Gift gift = {eligible: false, 'from, to, score: score_final};
        return gift;
    } else if (score_final < GOLD_BAR) {
        Gift gift = {eligible: true, 'from, to, score: score_final, details: {message: "Congratulations! You have won the SILVER gift!", 'type: SILVER}};
        return gift;
    } else if (score_final < PLATINUM_BAR) {
        Gift gift = {eligible: true, 'from, to, score: score_final, details: {message: "Congratulations! You have won the GOLD gift!", 'type: GOLD}};
        return gift;
    } else {
        Gift gift = {eligible: true, 'from, to, score: score_final, details: {'type: PLATINUM, message: "Congratulations! You have won the PLATINUM gift!"}};
        return gift;
    }
}

type Activities record {
    record {|
        string date;
        int value;
    |}[] activities\-steps;
};

type UserResult record {
    record {
        int age;
    } user;
};

type Gift record {
    boolean eligible;
    int score;
    # format yyyy-mm-dd
    string 'from;
    # format yyyy-mm-dd
    string to;
    record {|
        Types 'type;
        # message string: Congradulations! You have won the ${type} gift!;
        string message;
    |} details?;
};

enum Types {
    SILVER,
    GOLD,
    PLATINUM
}

const int SILVER_BAR = 5000;
const int GOLD_BAR = 10000;
const int PLATINUM_BAR = 20000;

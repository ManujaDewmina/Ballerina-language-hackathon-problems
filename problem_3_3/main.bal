// import ballerina/io;
import ballerina/http;

function findTheGiftSimple(string userID, string 'from, string to) returns Gift|error {
    final http:Client fifitEp = check new("https://localhost:9091/activities", auth = {
            refreshUrl: tokenEndpoint,
            refreshToken: refreshToken,
            clientId: clientId,
            clientSecret: clientSecret,
            clientConfig: {
                secureSocket: {
                    cert: "./resources/public.crt"
                }
            }
        },
        secureSocket = {
            cert: "./resources/public.crt"
        }
    );
    string u = "/steps/user/"+userID+"/from/"+'from+"/to/"+to;
    http:Response response = check fifitEp->get(u);
    if (response.statusCode != 200) {
        return error("Failed to get : " + response.statusCode.toString());
    }
    // get json payload from the response
    json payload = check response.getJsonPayload();
    
    //store the steps in Activities record
    Activities activities = check payload.cloneWithType(Activities);
    int totalSteps = 0;
    foreach var item in activities.activities\-steps {
        totalSteps = totalSteps + item.value;
    }

    if (totalSteps < SILVER_BAR) {
        Gift gift = {eligible: false, 'from, to, score: totalSteps};
        return gift;
    } else if (totalSteps < GOLD_BAR) {
        Gift gift = {eligible: true, 'from, to, score: totalSteps, details: {message: "Congratulations! You have won the SILVER gift!", 'type: SILVER}};
        return gift;
    } else if (totalSteps < PLATINUM_BAR) {
        Gift gift = {eligible: true, 'from, to, score: totalSteps, details: {message: "Congratulations! You have won the GOLD gift!", 'type: GOLD}};
        return gift;
    } else {
        Gift gift = {eligible: true, 'from, to, score: totalSteps, details: {'type: PLATINUM, message: "Congratulations! You have won the PLATINUM gift!"}};
        return gift;
    }
}

function findTheGiftComplex(string userID, string 'from, string to) returns Gift|error {
    // Write your answer here for Part B.
    // Two `http:Client`s are initialized for you. Please note that they do not include required security configurations.
    // A `Gift` record is initialized to make the given function compilable.
    // io:print(userID);
    // io:print('from);
    // io:print(to);
    // io:print("test1");
    // final http:Client fifitEp = check new("https://localhost:9091/activities");
    // io:print("test2");
    // // get response from the secure endpoint
    // http:Response response = check fifitEp->get("/" + userID + "?from=" + 'from + "&to=" + to);
    // io:print("test3");
    // // get json payload from the response
    // json payload = check response.getJsonPayload();
    // io:print("test4");
    // // print 
    // io:println(payload);

    // final http:Client insureEveryoneEp = check new("https://localhost:9092/insurance");
    Gift gift = {eligible: true, 'from, to, score: 99};
    return gift;
}

type Activities record {
    record {|
        string date;
        int value;
    |}[] activities\-steps;
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
        # message string: Congratulations! You have won the ${type} gift!;
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

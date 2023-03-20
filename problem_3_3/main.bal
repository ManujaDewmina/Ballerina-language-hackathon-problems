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

    final http:Client insureEveryoneEp = check new("https://localhost:9092/insurance",
        auth = {
            username: "alice",
            password: "123"
        },
        secureSocket = {
            cert: "./resources/public.crt"
        });
    http:Response response2 = check insureEveryoneEp->get("/user/"+userID);
    if (response2.statusCode != 200) {
        return error("Failed to get : " + response2.statusCode.toString());
    }
    // get json payload from the response   
    json payload2 = check response2.getJsonPayload();

    int age = check payload2.user.age;

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

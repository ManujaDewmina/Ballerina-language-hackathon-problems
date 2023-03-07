import ballerina/http;

function findTheGiftSimple(string userID, string 'from, string to) returns Gift|error {
    // Write your answer here for Part A.
    // An `http:Client` is initialized for you. Please note that it does not include required security configurations.
    // A `Gift` record is initialized to make the given function compilable.
    final http:Client fifitEp = check new("https://localhost:9091/activities");
    Gift gift = {eligible: true, 'from, to, score: 99};
    return gift;
}

function findTheGiftComplex(string userID, string 'from, string to) returns Gift|error {
    // Write your answer here for Part B.
    // Two `http:Client`s are initialized for you. Please note that they do not include required security configurations.
    // A `Gift` record is initialized to make the given function compilable.
    final http:Client fifitEp = check new("https://localhost:9091/activities");
    final http:Client insureEveryoneEp = check new("https://localhost:9092/insurance");
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

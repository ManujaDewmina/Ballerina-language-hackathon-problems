function findTheGift(string userID, string 'from, string to) returns Gift|error {
    // Write your answer here.
    // A `Gift` record is initialized to make the given function compilable.
    Gift gift = {eligible: true, 'from, to, score: 99};
    return gift;
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

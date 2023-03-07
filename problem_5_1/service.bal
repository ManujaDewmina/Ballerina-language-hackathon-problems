import ballerina/graphql;

// Don't change the port number
service /graphql on new graphql:Listener(9090) {

    // Write your answer here. You must change the input and
    // the output of the below signature along with the logic.
    resource function get sleepSummary() returns string {
        return "mock response";
    }
}

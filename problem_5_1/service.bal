import ballerina/graphql;
import ballerina/http;
import ballerina/io;

service class SleepSummary{
    // function init() {
    //     http:Client|error clientEP = new ("http://localhost:9091/activities/summary");
    //     if (clientEP is http:Client) {
    //         http:Response|error res = clientEP->get("/sleep/user/1");
    //         if (res is http:Response) {
    //             json|error payload = res.getJsonPayload();
    //             if (payload is json) {
    //                 io:println(payload);
    //             } else {
    //                 io:println("Error occurred while invoking the endpoint");
    //             }
    //         } else {
    //             io:println("Error occurred while invoking the endpoint");
    //         }
    //     } else {
    //         io:println("Error occurred while initializing client");
    //     }    
    // }

    // resource function get sleepSummary() returns string {
    //     io:print("Hello");
    //     return "Hello";
    // }

    private final string name;
    private final int age;

    function init(string name, int age) {
        io:println("Initializing the resource");
        self.name = name;
        self.age = age;
    }

    // Each resource method becomes a field of the `Profile` type.
    resource function get name() returns string {
        return self.name;
    }
    resource function get age() returns int {
        return self.age;
    }
    resource function get isAdult() returns boolean {
        return self.age > 21;
    }

} 


// Don't change the port number
service /graphql on new graphql:Listener(9090) {

    function init() {
        string id = "1";
        io:print("Initializing the service");
        http:Client|error clientEP = new ("http://localhost:9091/activities/summary");
        if (clientEP is http:Client) {
            http:Response|error res = clientEP->get("/sleep/user/"+id);
            io:println(res);
            if (res is http:Response) {
                json|error payload = res.getJsonPayload();
                if (payload is json) {
                    io:println(payload);
                } else {
                    io:println("Error occurred while invoking the endpoint 1");
                }
            } else {
                io:println("Error occurred while invoking the endpoint 2");
            }
        } else {
            io:println("Error occurred while initializing client");
        }    
    
    }

    resource function get sleepSummary() returns SleepSummary {
        io:println("Hello");
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

    return new ("Walter White", 51);
    }
}

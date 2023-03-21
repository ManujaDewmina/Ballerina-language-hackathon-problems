import problem_3_5.customers;
import problem_3_5.sales;
import ballerina/io;
import ballerina/http;

type Q "Q1"|"Q2"|"Q3"|"Q4";

type Quarter [int, Q];

type SalesResponse record {|
    *http:Ok;

    map<string> headers = {
        "content-type": "application/json"
    };
    sales:Sales[] body;
|};

function findTopXCustomers(Quarter[] quarters, int x) returns customers:Customer[]|error {
    http:Client salesClient = check new("http://localhost:8080/sales");
    http:Client customersClient = check new("http://localhost:8080/customers");

    //http:QueryParams queryParams = {year: 2021, quarter: "Q1"};
    
    //http response to sales response


    // http:Response customersResponse = check customersClient->/["1"];
    // //print response content 
    // io:println(salesResponse.getTextPayload());

    // //playload to json
    // json salesPayload = check salesResponse.getJsonPayload();
    // json customersPayload = check customersResponse.getJsonPayload();
    // io:println("test4");

    // io:print(customersPayload);
    // //print 
    // io:println("Sales: ", salesPayload);

    // //customer record array
    // customers:Customer[] custArray = [];

    // //customer json to customer record 
    // customers:Customer cust = check customersPayload.cloneWithType(customers:Customer);

    //sales json to sales record 
    //sales:Sales sale = check salesPayload.cloneWithType(sales:Sales);

    //print customer record
    //io:println("Customer: ", cust);

    //print sales record
    //io:println("Sales: ", sale);

    //print quarters year
    foreach var quarter in quarters {
        io:println("Year: ", quarter[0], " Quarter: ", quarter[1]);
    }	
    

    return [];
}

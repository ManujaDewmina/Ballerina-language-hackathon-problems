import problem_3_5.customers;
import problem_3_5.sales;
// import ballerina/io;
import ballerina/http;

type Q "Q1"|"Q2"|"Q3"|"Q4";

type Quarter [int, Q];

//record to hold the customer details
# Description
#
# + id - Field Description  
# + ammount - Field Description
type Cust record {
    string id;
    decimal ammount;
};

function findTopXCustomers(Quarter[] quarters, int x) returns customers:Customer[]|error {

    //cust array to hold the customer details
    Cust[] cust = [];
    
    foreach var quarter in quarters {
        http:Client customersClient = check new("http://localhost:8080/customers");
        http:Response customersResponse = check customersClient->/["1"];
        
        json customersJson = check customersResponse.getJsonPayload();
        
        http:Client salesClient = check new("http://localhost:8080/sales");
        http:Response salesResponse = check salesClient->/(year=quarter[0], quarter=quarter[1]);

        json salesJson = check salesResponse.getJsonPayload();

        //split the sales json into an array of sales
        json[] salesArray = <json[]>salesJson;

        //print the sales one by one
        foreach var sale in salesArray {

            sales:Sales saleRecord = check sale.cloneWithType(sales:Sales);
            //check whether the customer is already in the array'
            boolean found = false;
            foreach var c in cust {
                if (c.id == saleRecord.customerId) {
                    c.ammount = c.ammount + saleRecord.amount;
                    found = true;
                    break;
                }
            }
            //if not found, add the customer to the array
            if (!found) {
                Cust c = {id: saleRecord.customerId, ammount: saleRecord.amount};
                cust.push(c);
            }

            
        }
    }	

    //topx array to hold the top x customers
    
    //get 2 highest ammount customers from cust array
    foreach var item in cust {
        
    }
    
    
    return [];
}

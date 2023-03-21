import problem_3_5.customers;
import problem_3_5.sales;
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
    
    //decimal array to hold the ammounts
    decimal[] ammounts = [];

    //add the ammounts to the array
    foreach var item in cust {
        ammounts.push(item.ammount);
    }

    //sort the ammounts array
    decimal[] sort = ammounts.sort();

    //get the highest ammounts
    decimal[] highest = sort.slice(sort.length()-x, sort.length());


    //get the customers with the highest ammounts
    string[] topX = [];
    foreach var item in highest.reverse() {
        foreach var c in cust {
            if (c.ammount == item) {
                topX.push(c.id);
            }
        }
    }

    //iterate through the customers and get the customer details
    customers:Customer[] topCustomers = [];
    foreach var id in topX {
        http:Client customerClient = check new("http://localhost:8080/customers");
        http:Response customerResponse = check customerClient->/[id];
        json customerJson = check customerResponse.getJsonPayload();
        customers:Customer customer = check customerJson.cloneWithType(customers:Customer);
        topCustomers.push(customer);
    }

    return topCustomers;
}

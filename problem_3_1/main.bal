import ballerina/http;
// import ballerina/io;

# The exchange rate API base URL
configurable string apiUrl = "http://localhost:8080";


# Convert provided salary to local currency
#
# + salary - Salary in source currency
# + sourceCurrency - Soruce currency
# + localCurrency - Employee's local currency
# + return - Salary in local currency or error
public function convertSalary(decimal salary, string sourceCurrency, string localCurrency) returns decimal|error {

    // client endpoint configuration
    http:Client exchangeRateClient = check new http:Client (apiUrl);

    // http request
    http:Request req = new;

    // set path param
    req.rawPath = "/rates/{baseCurrency}";

//     // set query param
//     map<string> queryParam = { "to": localCurrency };
//     req.setQueryParams(queryParam);

//     // set path param
//     map<string> pathParam = { "baseCurrency": sourceCurrency };
//     req.setPathParam(pathParam);

//    http:Response|error response = exchangeRateClient->get(req);

//     // handle response
//     if (response is http:Response) {
//         if (response.statusCode == 200) {
//             json|error payload = response.getJsonPayload();
//             if (payload is json) {
//                 decimal rate = <decimal>(<json>payload).rates[localCurrency];
//                 return salary * rate;
//             } else {
//                 return payload;
//             }
//         } else {
//             return error("Error occurred while calling the backend service");
//         }
//     } else {
//         return response;
//     }
}



import ballerina/http;

# The exchange rate API base URL
configurable string apiUrl = "http://localhost:8080";

# Convert provided salary to local currency
#
# + salary - Salary in source currency
# + sourceCurrency - Soruce currency
# + localCurrency - Employee's local currency
# + return - Salary in local currency or error
public function convertSalary(decimal salary, string sourceCurrency, string localCurrency) returns decimal|error {
    
    //http client to call the exchange rate API
    http:Client exchangeRateClient = check new (apiUrl);

    // Create the request message with the provided salary and source currency
    http:Request request = new;

    // Set the JSON payload
    json payload = {
        "salary": salary,
        "sourceCurrency": sourceCurrency
    };

    request.setJsonPayload(payload);

    /// Send a POST request to the exchange rate API
    http:Response response = check exchangeRateClient->post("/exchange-rate", request);

    // Extract the JSON payload from the response
    json responsePayload = check response.getJsonPayload();

    // Extract the converted salary from the JSON payload
    decimal convertedSalary = check responsePayload.convertedSalary;

    // Return the converted salary
    return convertedSalary;
}


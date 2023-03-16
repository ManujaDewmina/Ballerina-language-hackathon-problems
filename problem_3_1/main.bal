import ballerina/http;

# The exchange rate API base URL
configurable string apiUrl = "http://localhost:8080";

type Rates record {
    string base;
    map<decimal> rates;
};

# Convert provided salary to local currency
#
# + salary - Salary in source currency
# + sourceCurrency - Soruce currency
# + localCurrency - Employee's local currency
# + return - Salary in local currency or error
public function convertSalary(decimal salary, string sourceCurrency, string localCurrency) returns decimal|error {

    // Create the HTTP client
    http:Client httpClient = check new (apiUrl);
    // Get the exchange rates
    // Get the exchange rates
    http:Response response = check httpClient->get("/rates/" + sourceCurrency);
    if (response.statusCode != 200) {
        return error("Failed to get exchange rates: " + response.statusCode.toString());
    }

    json ratesJson = check response.getJsonPayload();

    Rates rates = check ratesJson.cloneWithType(Rates);

    // Get the exchange rate for the local currency
    decimal? rate = rates.rates[localCurrency];
    if (rate is ()) {
        return error("Failed to get exchange rate for " + localCurrency);
    }

    // Calculate the salary in local currency
    return salary * rate;
}



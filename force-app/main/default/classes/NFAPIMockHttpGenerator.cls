@isTest
global class NFAPIMockHttpGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('https://nfapihub.herokuapp.com/', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"success":true,"secretKey":"secret key"}');
        res.setStatusCode(200);
        return res;
    }
}
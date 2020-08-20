global class BatchCasesClosed implements Database.Batchable<sObject>, Database.AllowsCallouts{
     
    global Database.QueryLocator start(Database.BatchableContext bc){
        //String queue = 'A';
        //set limit of 200 here to be a custom setting for control
        String soqlQuery = 'select id, lastmodifiedbyid, NFAPI_SecretKey__c, NFAPI_Last_Reponse_Code__c, NFAPI_Last_Error_Message__c, nfapi_requires_processing__c,NFAPI_Processing_Queue__c from case where nfapi_requires_processing__c=true limit 200';
        return Database.getQueryLocator(soqlQuery);
    }
     
    global void execute(Database.BatchableContext bc, List<case> caselist){
        
        for (case cas : caselist){
            string jsonresponse;
        
            //construct httprequest and payload
            
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        string payload = 'id='+cas.id+'&agentid='+cas.LastModifiedById;
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setEndpoint('https://nfapihub.herokuapp.com/'); //custom setting
        request.setMethod('POST');
        request.setBody(payload);
        request.setTimeout(300);  //make timeout a custom setting, keeping it low seems to improve performance.
        
            try     {
                    
                	response = http.send(request);
                    system.debug('Response Object-'+response);
                    jsonResponse = response.getBody();
                    System.debug('Body Response-' + jsonResponse);
                    
                    //call parsing method
                    nfapiresponseparser.responsewrapper resp = nfapiresponseparser.nfapiresponse(jsonresponse);
                    system.debug('response: '+resp);
                    cas.NFAPI_SecretKey__c=resp.secretKey;
                    
                	//did we get a secret key returned?
                	if (resp.secretKey!=null) {
                    	cas.nfapi_requires_processing__c=false;
                    }
                	
                	//update last response code and error
                    cas.NFAPI_Last_Reponse_Code__c=response.getStatusCode();
                    cas.NFAPI_Last_Error_Message__c=resp.error;
                    
                    }
            		//trap errors and also store in the event of hard timeout or something else
                    catch (exception e) {
                        System.debug('exception: ' + e);
                        cas.NFAPI_Last_Error_Message__c=e.getMessage();
                    // may return something like 'System.CalloutException: Read timed out' for hard timeout
                    
                    
                }
            
            
        }
        update caselist;
    } 
    
    global void finish(Database.BatchableContext bc){
            
        integer count= database.countQuery('select count() from case where nfapi_requires_processing__c=true'); 
        //if we still have jobs that require processing, then keep chaining the batch
        if (count>0) {
            BatchCasesClosed schBatch = new BatchCasesClosed(); 
            Id batchId = Database.executeBatch(schBatch, 50);  // change this number to a custom setting so that it can be easily altered 
        }
        //insert some sort of code here to monitor the situation if required.
    }
}
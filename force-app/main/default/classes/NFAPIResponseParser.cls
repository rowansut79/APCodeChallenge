public class NFAPIResponseParser {

    public static responsewrapper nfapiresponse(string jsonString) {
       //convert json response string into a wrapper class object   
       NFAPIResponseParser.responsewrapper nfresponse = (responsewrapper)system.json.deserialize(jsonString, responsewrapper.class);
       return nfresponse; 
    }

public class responsewrapper {
    public boolean success {get; set;}
    public string error {get; set;}
    public string secretKey {get; set;}
    
}  
}
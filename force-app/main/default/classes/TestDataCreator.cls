public class TestDataCreator {
    public static List<case> createCases(Integer numCases) {
        List<case> caselist = new List<case>();
        for (integer i=0;i<numCases;i++) {
    		case cas = new case();
    		cas.origin='Email';
    		cas.subject=string.valueof('Case ' + i);
            cas.NFAPI_Requires_Processing__c=True;
    		caselist.add(cas);
    		cas.status='New';    
		}
	return caselist;    
    }
}
@isTest	
private class TestBatchCasesScheduler {
	
    static testmethod void schedulertest() {
    	String CRON_EXP = '0 0 0 20 8 ? 2025';
    	list<case> caselist = TestDataCreator.createCases(50);
        insert caselist;
        Test.setMock(HttpCalloutMock.class, new NFAPIMockHttpGenerator());
        Test.startTest();
    	String jobId = System.schedule('ScheduledApexTest',CRON_EXP,new BatchCasesScheduler());         
        Test.stopTest();
    }
}
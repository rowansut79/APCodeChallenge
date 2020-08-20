@isTest
public class TestBatchCasesClosed {

    static testmethod void testbatchcasesclosed() {        
        //create test data
        list<case> caselist = TestDataCreator.createCases(50);
        insert caselist;
        Test.setMock(HttpCalloutMock.class, new NFAPIMockHttpGenerator());
        Test.startTest();
        BatchCasesClosed schBatch = new BatchCasesClosed(); 
		Id batchId = Database.executeBatch(schBatch, 50);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        //System.assertEquals(10, [select count() from contact where MailingCity = 'New York']);
    }
    
}
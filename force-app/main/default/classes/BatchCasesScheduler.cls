global class BatchCasesScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        
        //is there any work that needs doing?
        integer count= database.countQuery('select count() from case where nfapi_requires_processing__c=true');
        
        //check if any batch jobs are running of the BatchCasesClosed class
        list<string> jobstatus = new string[]{'Holding','Queued','Preparing','Processing'};
        list<asyncapexjob> aaj = [SELECT ApexClassId,CompletedDate,CreatedById,CreatedDate,ExtendedStatus,Id,JobItemsProcessed,JobType,LastProcessed,LastProcessedOffset,MethodName,NumberOfErrors,ParentJobId,Status,TotalJobItems FROM AsyncApexJob where status in :jobstatus and apexclassid in (Select Id from ApexClass where Name = 'BatchCasesClosed')];
        
        //Is there is work to do? Is the batch job already running?   
        if (aaj.size()==0 && count > 0) {  
            BatchCasesClosed schBatch = new BatchCasesClosed(); 
            Id batchId = Database.executeBatch(schBatch, 50);  // change this number to a custom setting so that it can be easily altered
        }
    }
}
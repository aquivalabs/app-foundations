@NamespaceAccessible
public with sharing abstract class SetupStep {

    // ABSTRACT

    @NamespaceAccessible
    public abstract ApexPages.Message getStatus();
    @NamespaceAccessible
    public abstract PageReference run();

    // PUBLIC

    @NamespaceAccessible
    public Boolean success {
        get {
            try {
                return (getStatus().getSeverity() == ApexPages.Severity.CONFIRM);
            }
            catch(Exception ex) {
                return false;
            }
        }
        private set;
    }


    @NamespaceAccessible
    public String getMessage() {
        return getStatus().getSummary();
    }


    @NamespaceAccessible
    public String getSeverity() {
        return getStatus().getSeverity().name();
    }
    

    @NamespaceAccessible
    public PageReference doRun() {
        PageReference result = null;

        try {
            result = run();
        }
        catch(Exception ex) {
            ApexPages.addMessages(ex);
            System.debug(LoggingLevel.ERROR, '' +  ex);
        }

        return result;
    }


    @NamespaceAccessible
    public String buttonLabel {
        get {
            return buttonLabel();
        }
    }


    @NamespaceAccessible
    public virtual String buttonLabel() {
        return 'Execute';
    }


    @NamespaceAccessible
    public virtual Boolean getShowButtonOnSuccess() {
        return false;
    }


    @NamespaceAccessible
    protected String setupLink(List<SObject> records) {
        SObjectType type = records.getSObjectType();
        Id id = null;

        if(!records.isEmpty() && records[0] != null) {
            type = records[0].getSObjectType();
            id = records[0].Id;
        }

        return setupLink(id, '' + type, type.getDescribe().getLabel());
    }


    @NamespaceAccessible
    protected String setupLink(SObject record) {
        return setupLink(new List<SObject>{ record });
    }


    @NamespaceAccessible
    protected String setupLink(SObjectType type) {
        return '<b><a href="/lightning/setup/ObjectManager/' + type + '/FieldsAndRelationships/view" target="_blank">' + type.getDescribe().getLabel() + '</a></b>';
    }


    @NamespaceAccessible
    protected String setupLink(String id, String type, String label) {
        return (id == null) ? '<b>' + label + '</b>'  : '<b><a href="/lightning/setup/' + type + '/page?address=%2F' + id +'" target="_blank">' + label + '</a></b>';
    }


    @NamespaceAccessible
    protected String setupLink(String fragment, String label) {
        return '<b><a href="/lightning/setup/' + fragment + '" target="_blank">' + label + '</a></b>';
    }


    @NamespaceAccessible
    protected String link(String label, String url) {
        return '<b><a href="' + url +'" target="_blank">' + label + '</a></b>';
    }


    @NamespaceAccessible
    protected PageReference currentPage() {
        PageReference result = ApexPages.currentPage();
        result.setRedirect(true);
        return result;
    }

    // INNER

    @NamespaceAccessible
    public with sharing abstract class ForBatch extends SetupStep {

        @NamespaceAccessible
        public abstract void execute();

        @NamespaceAccessible
        public virtual override ApexPages.Message getStatus() {
            if(countBatchWithStatus(new List<String>{'Failed', 'Aborted'}) > 0) {
                return new ApexPages.Message(ApexPages.Severity.ERROR, 'Batch job failed. Check the logs.');
            }
            else if(countBatchWithStatus(new List<String>{'Holding', 'Queued', 'Preparing', 'Processing'}) > 1) {
                return new ApexPages.Message(ApexPages.Severity.INFO, 'Batch job pending. Check the logs.');
            }
            else if(countBatchWithStatus(new List<String>{'Completed'}) == 1) {
                return new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Batch job completed.');
            }

            return null;
        }


        @NamespaceAccessible
        public override String buttonLabel() {
            return 'Run...';
        }


        @NamespaceAccessible
        public override PageReference run() {
            execute();
            return new PageReference('/apexpages/setup/listAsyncApexJobs.apexp');
        }


        // Note: PMD False Positive as app must use System mode for System object
        @SuppressWarnings('PMD.ApexCRUDViolation')
        private Integer countBatchWithStatus(List<String> statuses) {
            String className = String.valueOf(this).split(':')[0];
            return [SELECT COUNT() FROM AsyncApexJob 
                    WHERE Status IN :statuses AND ApexClass.Name LIKE :className
                    WITH SYSTEM_MODE];
        }
    }


    @NamespaceAccessible
    public class MetadataServiceException extends Exception {}


    @NamespaceAccessible
    public class ToolingApiResponse {
        public List<SObject_x> records;
    }


    @NamespaceAccessible
    public class SObject_x {
        public String Id;
        public String DeveloperName;
    }
}
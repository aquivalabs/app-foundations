@NamespaceAccessible
public with sharing abstract class SetupCtrl {

    @NamespaceAccessible
    public SetupCtrl controller { get; private set; }

    // CONSTRUCTOR

    @NamespaceAccessible
    public SetupCtrl() {
        controller = this;
    }


    // PUBLIC

    @NamespaceAccessible
    public abstract List<SetupStep> steps();


    @NamespaceAccessible
    public Integer getProgress() {
        Integer result = 0;

        List<SetupStep> steps = steps();

        for(SetupStep step : steps) {
            if(step.success) {
                result += 100;
            }
        }

        return result / steps.size();
    }


    @NamespaceAccessible
    public String getClasses() {
        return (getProgress() == 100) ? 'slds-progress-bar__value_success' : '';
    }
}
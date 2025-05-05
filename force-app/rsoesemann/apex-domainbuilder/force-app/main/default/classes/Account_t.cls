@NamespaceAccessible
public class Account_t extends DomainBuilder {
    @NamespaceAccessible
    public Account_t() {
        super(Account.SObjectType);

        name('Acme Corp');
    }

    @NamespaceAccessible
    public Account_t name(String value) {
        return (Account_t) set(Account.Name, value);
    }

    @NamespaceAccessible
    public Account_t add(Opportunity_t o) {
        return (Account_t) o.setParent(Opportunity.AccountId, this);
    }

    @NamespaceAccessible
    public Account_t add(Contact_t c) {
        return (Account_t) c.setParent(Contact.AccountId, this);
    }
}

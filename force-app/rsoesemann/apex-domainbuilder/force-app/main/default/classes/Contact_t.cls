@SuppressWarnings('PMD')
@NamespaceAccessible
public class Contact_t extends DomainBuilder {

    @NamespaceAccessible
    public Contact_t(Account_t a) {
        super(Contact.SObjectType);
        setParent(Contact.AccountId, a);

        last(new Random().string());
    }

    @NamespaceAccessible
    public Contact_t() {
        this(new Account_t());
    }

    @NamespaceAccessible
    public Contact_t first(String value) {
        return (Contact_t) set(Contact.FirstName, value);
    }

    @NamespaceAccessible
    public Contact_t last(String value) {
        return (Contact_t) set(Contact.LastName, value);
    }

    @NamespaceAccessible
    public Contact_t email(String value) {
        return (Contact_t) set(Contact.Email, value);
    }

    @NamespaceAccessible
    public Contact_t reports(Contact_t c) {
        return (Contact_t) setParent(Contact.ReportsToId, c);
    }
}

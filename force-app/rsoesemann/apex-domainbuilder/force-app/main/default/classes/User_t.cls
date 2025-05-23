@SuppressWarnings('PMD')
@NamespaceAccessible
public class User_t extends DomainBuilder {
    private static final Id STANDARD_USER = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id;

	// CONSTRUCTORS

    @NamespaceAccessible
    public User_t() {
        super(User.SObjectType);

        String name = new Random().string();
        set(User.Alias, 'alias');
        set(User.Email, name + '@scott.com');
        set(User.EmailEncodingKey, 'UTF-8');
        set(User.FirstName, 'Jill');
        set(User.Lastname, 'Scott');
        set(User.languagelocalekey, 'en_US');
        set(User.localesidkey, 'en_US');
        set(User.timezonesidkey, 'America/Los_Angeles');
        set(User.isActive, true);
        set(User.username, name + '@scott.com');
        set(User.profileId, STANDARD_USER);
        set(User.UserPermissionsSFContentUser, false);
    }

    @NamespaceAccessible
    public static User standard(String permsetName) {
        User result = standard();
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = :permsetName];
        insert new PermissionSetAssignment(AssigneeId = result.Id, PermissionSetId = ps.Id);
        return result;
    }

    @NamespaceAccessible
    public static User standard() {
        return (User) new User_t().set(User.profileId, STANDARD_USER).persist();
    }
}

@NamespaceAccessible
public class Opportunity_t extends DomainBuilder {

	@NamespaceAccessible
	public Opportunity_t(Account_t a) {
		super(Opportunity.SObjectType);
		setParent(Opportunity.AccountId, a);

		name('Opp1');
		stage('Open');
		closes(System.today().year()+1, 1);
	}

	@NamespaceAccessible
	public Opportunity_t() {
		this(new Account_t());
	}

	@NamespaceAccessible
	public Opportunity_t name(String value) {
		return (Opportunity_t) set(Opportunity.Name, value);
	}

	@NamespaceAccessible
	public Opportunity_t amount(Decimal value) {
		return (Opportunity_t) set(Opportunity.Amount, value);
	}

	@NamespaceAccessible
	public Opportunity_t stage(String value) {
		return (Opportunity_t) set(Opportunity.StageName, value);
	}

	@NamespaceAccessible
	public Opportunity_t contact(Contact_t c) {
		new OpportunityContactRole_t(this, c);
		return this;
	}

	@NamespaceAccessible
	public Opportunity_t closes(Integer y, Integer m) {
		return (Opportunity_t) set(Opportunity.CloseDate, Date.newInstance(y, m, 1));
	}

	@NamespaceAccessible
	public Opportunity_t add(Contact_t c) {
		new OpportunityContactRole_t(this, c);
		return this;
	}
}

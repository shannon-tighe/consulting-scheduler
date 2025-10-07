public with sharing class NewAppointmentFormController {

    public class ContactSkill {
        @AuraEnabled public Id Id { get; set; }
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public Integer skillLevel { get; set; }
        @AuraEnabled public String valueRanking { get; set; }

        public ContactSkill() {}

        public ContactSkill(Id i, String n, Integer s, String v) {
            this.Id = i;
            this.name = n;
            this.skillLevel = s;
            this.valueRanking = v;
        } 
    }
    

    @AuraEnabled(cacheable=true)
    public static List<ContactSkill> getContactSkills(Id contactId){
        System.debug('Conatct Id ==> ' + contactId);

        List<ContactSkill> contactSkills = new List<ContactSkill>();

        try {
            // Query and store this Contact's skills
            for(ContactSkill__c cs : queryContactSkills(contactId)) {
                ContactSkill csData = new ContactSkill(
                    cs.Id,
                    cs.Name,
                    Integer.valueOf(cs.Skill_Level__c),
                    cs.Skill__r.Value_Ranking__c
                );

                contactSkills.add( csData );
            }

            System.debug('Data ==>\n' + contactSkills);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return contactSkills;
    }

    static List<ContactSkill__c> queryContactSkills(Id contactId) {
        return [
            SELECT
                Id, Name, Skill_Level__c, Skill__r.Value_Ranking__c
            FROM
                ContactSkill__c
            WHERE
                Contact__c = :contactId
        ];
    }

    @AuraEnabled
    public static voId updateContactSkills(List<ContactSkill> skillz) {
        System.debug('Skills:\n' + skillz);
        List<ContactSkill__c> updateSkillz = new List<ContactSkill__c>();

        for(ContactSkill sk : skillz) {
            updateSkillz.add(new ContactSkill__c(
                Id = sk.Id,
                Name = sk.name,
                Skill_Level__c = String.valueOf(sk.skillLevel)
            ));
        }

        update updateSkillz;
    }
}
/**
 * @description Data Transfer Objects (DTOs) for values read from ContactSkill__c (junction).
 *              Keep these read-only; they represent stable contracts returned by selectors/search.
 * @since 1.0.0
 * @group DTO
 */
public class DTO_ContactSkill {

    /**
     * @description Minimal projection for common junction use cases (lightweight).
     * @since 1.0.0
     */
    public class RowCore {
        /** @description ContactSkill junction Id. */
        public Id id;
        /** @description Junction Contact Id. */
        public Id contactId;
        /** @description Junction Skill Id. */
        public Id skillId;
        /** @description Junction Name (often mirrors Skill.Name). */
        public String name;

        /**
         * @description Constructs a RowCore DTO for ContactSkill.
         * @param id Junction Id.
         * @param contactId Contact Id.
         * @param skillId Skill Id.
         * @param name Junction Name.
         */
        public RowCore(Id id, Id contactId, Id skillId, String name) {
            this.id = id;
            this.contactId = contactId;
            this.skillId = skillId;
            this.name = name;
        }
    }

    /**
     * @description Audit-friendly projection with system timestamps.
     *              Useful for admin UI, sync, or audit listings.
     * @since 1.0.0
     */
    public class RowAudit {
        /** @description ContactSkill junction Id. */
        public Id id;
        /** @description Junction Contact Id. */
        public Id contactId;
        /** @description Junction Skill Id. */
        public Id skillId;
        /** @description Junction Name. */
        public String name;
        /** @description CreatedDate of the junction record. */
        public Datetime createdDate;
        /** @description LastModifiedDate of the junction record. */
        public Datetime lastModifiedDate;

        /**
         * @description Constructs a RowAudit DTO for ContactSkill.
         * @param id Junction Id.
         * @param contactId Contact Id.
         * @param skillId Skill Id.
         * @param name Junction Name.
         * @param createdDate CreatedDate timestamp.
         * @param lastModifiedDate LastModifiedDate timestamp.
         */
        public RowAudit(Id id, Id contactId, Id skillId, String name,
                        Datetime createdDate, Datetime lastModifiedDate) {
            this.id = id;
            this.contactId = contactId;
            this.skillId = skillId;
            this.name = name;
            this.createdDate = createdDate;
            this.lastModifiedDate = lastModifiedDate;
        }
    }

    /**
     * @description Detail projection including a nested Skill DTO for convenience when
     *              rendering UI or performing validations that need Skill context.
     * @since 1.0.0
     */
    public class RowDetail {
        /** @description ContactSkill junction Id. */
        public Id id;
        /** @description Junction Contact Id. */
        public Id contactId;
        /** @description Junction Skill Id. */
        public Id skillId;
        /** @description Junction Name. */
        public String name;
        /** @description Nested minimal Skill projection (Id/Name). */
        public DTO_Skill.RowCore skill;

        /**
         * @description Constructs a RowDetail DTO for ContactSkill.
         * @param id Junction Id.
         * @param contactId Contact Id.
         * @param skillId Skill Id.
         * @param name Junction Name.
         * @param skill Minimal Skill DTO (Id/Name).
         */
        public RowDetail(Id id, Id contactId, Id skillId, String name, DTO_Skill.RowCore skill) {
            this.id = id;
            this.contactId = contactId;
            this.skillId = skillId;
            this.name = name;
            this.skill = skill;
        }
    }
}
/**
 * @description Data Transfer Objects (DTOs) for values read from Skill__c.
 *              These define stable "read contracts" returned by selectors/search.
 * @since 1.0.0
 * @group DTO
 */
public class DTO_Skill {

    /**
     * @description Minimal projection for lookups, stamping, and typeahead.
     *              Intentionally excludes mutable fields to prevent accidental DML usage.
     * @since 1.0.0
     */
    public class RowCore {
        /** @description Skill record Id (immutable identifier). */
        public Id id;
        /** @description Skill Name, used frequently in UI and junction naming. */
        public String name;

        /**
         * @description Constructs a minimal RowCore DTO.
         * @param id Skill Id.
         * @param name Skill Name.
         */
        public RowCore(Id id, String name) {
            this.id = id;
            this.name = name;
        }
    }

    /**
     * @description Audit-friendly projection with timestamps.
     *              Useful for admin UI, sync, or audit listings.
     * @since 1.0.0
     */
    public class RowAudit {
        /** @description Skill record Id. */
        public Id id;
        /** @description Skill Name. */
        public String name;
        /** @description CreatedDate of the Skill. */
        public Datetime createdDate;
        /** @description LastModifiedDate of the Skill. */
        public Datetime lastModifiedDate;

        /**
         * @description Constructs an audit DTO for Skill.
         * @param id Skill Id.
         * @param name Skill Name.
         * @param createdDate CreatedDate timestamp.
         * @param lastModifiedDate LastModifiedDate timestamp.
         */
        public RowAudit(Id id, String name, Datetime createdDate, Datetime lastModifiedDate) {
            this.id = id;
            this.name = name;
            this.createdDate = createdDate;
            this.lastModifiedDate = lastModifiedDate;
        }
    }
}
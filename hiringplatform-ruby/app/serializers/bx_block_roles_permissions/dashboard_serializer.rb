module BxBlockRolesPermissions
  class DashboardSerializer < BuilderBase::BaseSerializer
    attributes *[
                 :name,
                 :shortlisted_candidates,
                 :under_assessment,
                 :data_opened,
               ]

    attribute :shortlisted_candidates do |object|
      shortlisted_candidates(object, "true")
    end

    attribute :under_assessment do |object|
      shortlisted_candidates(object, "false")
    end

    attribute :data_opened do |object|
      object.created_at
    end

    class << self
      private

      def shortlisted_candidates(object, is_shortlisted)
        if object.job_description
          BxBlockShortlisting::ShortlistingCandidate.where(job_description_id: object.job_description.id, shortlisted_by_admin: is_shortlisted).count
        else
          0
        end
      end
    end
  end
end

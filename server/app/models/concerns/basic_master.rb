module BasicMaster
  extend ActiveSupport::Concern

  included do
    belongs_to :project
    validates :name, :project_id, presence: true
    validates :project_id, uniqueness: { scope: [:name] }

    scope :of_project_and_names, ->(project_id, names) {
            if (project_id.present? && (safe_names = (names || []).reject(&:blank?)).present?)
              where(project_id: project_id, name: safe_names)
            end
          }
  end
end

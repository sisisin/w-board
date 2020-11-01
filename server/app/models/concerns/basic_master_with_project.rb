module BasicMasterWithProject
  extend ActiveSupport::Concern

  included do
    belongs_to :project
    validates :name, :project_id, presence: true
    validates :project_id, uniqueness: { scope: [:name] }

    scope :of_names, ->(names) {
      if ((safe_names = (names || []).reject(&:blank?)).present?)
        where(name: safe_names)
      end
    }
  end
end

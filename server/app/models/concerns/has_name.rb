module HasName
  extend ActiveSupport::Concern

  included do
    scope :of_names, ->(names = []) {
        if (safe_names = (names || []).reject(&:blank?)).present?
          where(name: safe_names)
        end
      }
  end
end

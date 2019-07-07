class LanguageSummary < ApplicationRecord
  belongs_to :language

  def name
    language.name
  end
end

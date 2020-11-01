# frozen_string_literal: true

class LanguageSummary < ApplicationRecord
  belongs_to :language

  def digital
    Time.at(total_seconds).utc.strftime('%H:%M:%S')
  end

  def name
    if attributes['name']
      attributes['name']
    elsif attributes['language_id']
      language.name
    end
  end
end

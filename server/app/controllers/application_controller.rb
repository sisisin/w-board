class ApplicationController < ActionController::API
  def index
    langs = LanguageSummary
      .joins(:language)
      .group("languages.name")
      .group(:date)
      .select(:date, "SUM(total_seconds) as total_seconds", "languages.name as name")

    render json: langs.as_json(only: [:date], methods: [:digital, :name])
  end
end

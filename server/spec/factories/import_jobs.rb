FactoryBot.define do
  factory :import_job do
    status { "waiting" }
    target_date { "2019-07-04" }
  end
end

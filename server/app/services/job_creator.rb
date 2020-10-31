class JobCreator
  def run(target_date = Date.yesterday)
    Rails.logger.info "create job at #{DateTime.now}"

    ImportJob.create_with(status: :waiting).find_or_create_by!(target_date: target_date)
  end

  def run_with_date(date_str)
    Rails.logger.info "create job at #{DateTime.now}"

    if date_str.nil?
      raise ArgumentError.new("Arguments must be specified")
    end

    begin
      target_date = Date.parse(date_str)
    rescue => exception
      raise ArgumentError.new("Invalid Date: #{date_str}")
    end

    ImportJob.create(target_date: target_date, status: :waiting)
  end
end

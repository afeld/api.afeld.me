# frozen_string_literal: true

module ResumeHelpers
  def all_jobs
    jobs = (data.resume.experience.coding + data.resume.experience.teaching).sort_by(&:start_date).reverse

    # put current jobs in front of past ones
    current = jobs.select { |job| job.end_date.nil? }
    past = jobs.select { |job| job.end_date.present? }

    current + past
  end

  def skill_years(jobs)
    results = Hash.new(0)
    jobs.each do |job|
      next unless job.skills? && job.skills.any?

      start = parse_date(job.start_date)
      end_date = job.end_date? ? parse_date(job.end_date) : Date.today
      years_experience = ((end_date - start) / 365).ceil
      job.skills.each do |skill|
        results[skill] = [years_experience, results[skill]].max
      end
    end

    results
  end

  def skills(jobs, num_years_range)
    # TODO: don't recompute every time
    results = skill_years(jobs).select { |_skill, yrs| num_years_range.include?(yrs) }.keys
    results.sort_by!(&:downcase)
    results
  end

  def hours_per_week(hours)
    "#{hours} #{"hour".pluralize(hours)}/week"
  end

  def num_employees(job)
    if job.respond_to? :employees
      num = number_with_delimiter(job.employees)
      "#{num} employees"
    end
  end

  def date_row(job)
    [
      date_range(job),
      hours_per_week(job.hours),
      # num_employees(job)
    ].compact.join(", ")
  end
end

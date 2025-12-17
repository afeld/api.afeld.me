# frozen_string_literal: true

module ResumeHelpers
  def all_jobs
    coding = data.resume.experience.coding
    teaching = data.resume.experience.teaching

    # present jobs: coding before teaching, each sorted by start_date desc
    current_coding = coding.select { |job| job.end_date.nil? }
    current_coding_sorted = current_coding.sort_by(&:start_date)
    current_coding = current_coding_sorted.reverse

    current_teaching = teaching.select { |job| job.end_date.nil? }
    current_teaching_sorted = current_teaching.sort_by(&:start_date)
    current_teaching = current_teaching_sorted.reverse

    # past jobs: merge categories and sort by start_date desc
    past_coding = coding.select { |job| job.end_date.present? }
    past_teaching = teaching.select { |job| job.end_date.present? }
    past_merged = past_coding + past_teaching
    past_sorted = past_merged.sort_by(&:start_date)
    past = past_sorted.reverse

    current_coding + current_teaching + past
  end

  private

  def organize_jobs(jobs)
    # put current jobs in front of past ones, only sorting current jobs
    current = jobs.select { |job| job.end_date.nil? }.sort_by(&:start_date).reverse
    past = jobs.select { |job| job.end_date.present? }

    current + past
  end

  def skill_years(jobs)
    results = Hash.new(0)
    jobs.each do |job|
      next unless job.skills? && job.skills.any?

      start = parse_date(job.start_date)
      end_date = if job.end_date?
                   parse_date(job.end_date)
                 else
                   Date.today
                 end
      years_experience = ((end_date - start) / 365).ceil
      job.skills.each do |skill|
        results[skill] = [years_experience, results[skill]].max
      end
    end

    results
  end

  def skills(jobs, num_years_range)
    # TODO: don't recompute every time
    years_by_skill = skill_years(jobs)
    filtered = years_by_skill.select { |_skill, yrs| num_years_range.include?(yrs) }
    result_keys = filtered.keys
    result_keys.sort_by!(&:downcase)
    result_keys
  end

  def hours_per_week(hours)
    unit = "hour".pluralize(hours)
    "#{hours} #{unit}/week"
  end

  def num_employees(job)
    if job.respond_to? :employees
      num = number_with_delimiter(job.employees)
      "#{num} employees"
    end
  end

  def date_row(job)
    parts = [date_range(job)]
    compacted = parts.compact
    compacted.join(", ")
  end
end

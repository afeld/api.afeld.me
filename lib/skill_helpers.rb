# frozen_string_literal: true

module SkillHelpers
  def skill_years(jobs)
    results = Hash.new(0)
    jobs.each do |job|
      # they all get lumped together in this time range, so exclude it
      next if job.organization == 'Open source contribution'
      next unless job['skills'] && job.skills.any?

      start = parse_date(job.start_date)
      # TODO: don't assume all skills have been used continuously
      years_experience = years_since(start)
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
    hours == 1 ? '1 hour/week' : "#{hours} hours/week"
  end

  def date_row(job)
    employees = ("#{job.employees} employees" if job.respond_to? :employees)

    [
      date_range(job),
      hours_per_week(job.hours),
      employees
    ].compact.join(', ')
  end
end

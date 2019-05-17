module TimeHelpers
  def month_only?(date_str)
    date_str.scan('-').size == 1
  end

  def parse_date(date_str)
    if month_only?(date_str)
      Date.strptime(date_str, '%Y-%m')
    else
      Date.parse(date_str)
    end
  end

  def date(date_str)
    obj = parse_date(date_str)
    format_str = month_only?(date_str) ? '%b %Y' : '%b %-m, %Y'
    obj.strftime(format_str)
  end

  def date_range(obj)
    start_date = date(obj.start_date)
    end_date = obj['end_date'] ? date(obj.end_date) : 'present'
    "#{start_date} — #{end_date}"
  end

  # https://stackoverflow.com/a/1904193/358804
  def years_since(date)
    delta = (Date.today - date) / 365
    delta.ceil
  end
end

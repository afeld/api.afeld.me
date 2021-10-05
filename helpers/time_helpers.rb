require 'date'

module TimeHelpers
  def month_only?(date_str)
    date_str.scan('-').size == 1
  end

  def parse_date(date_str)
    if month_only?(date_str)
      Date.strptime(date_str, '%Y-%m')
    else
      Date.parse(date_str, '%Y-%m-%d')
    end
  end

  def date(date_str)
    obj = parse_date(date_str)

    if month_only?(date_str)
      datetime = obj.strftime("%Y-%m")
      display_date = obj.strftime('%b %Y')
    else
      datetime = obj.strftime("%Y-%m-%d")
      display_date = obj.strftime('%b %-d, %Y')
    end

    "<time datetime=\"#{datetime}\">#{display_date}</time>"
  end

  def date_range(obj)
    start_date = date(obj.start_date)
    end_date = obj['end_date'] ? date(obj.end_date) : 'present'
    "#{start_date} — #{end_date}"
  end

  def infinity
    # https://banisterfiend.wordpress.com/2009/10/02/wtf-infinite-ranges-in-ruby/
    1.0 / 0.0
  end
end

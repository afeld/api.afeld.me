# frozen_string_literal: true

require 'json'
require 'sinatra/asset_pipeline'
require 'sinatra/respond_with'
require 'sprockets-helpers'

if development?
  require 'sinatra/reloader'
  enable :reloader
elsif test?
  enable :show_exceptions
end

enable :logging
register Sinatra::AssetPipeline

configure do
  set :assets_css_compressor, :sass
  set :assets_precompile, %w[*.css]
end

path = File.expand_path('views/index.json', __dir__)
PROFILE_STR = File.read(path).freeze
PROFILE_HSH = JSON.parse(PROFILE_STR).to_dot.freeze
JOBS = (PROFILE_HSH.experience.coding + PROFILE_HSH.experience.teaching).sort_by(&:start_date).reverse

# https://banisterfiend.wordpress.com/2009/10/02/wtf-infinite-ranges-in-ruby/
INF = 1.0 / 0.0

helpers do
  include Sprockets::Helpers

  def to_html(val)
    case val
    when Array
      to_ul(val)
    when Hash
      to_dl(val)
    else
      val
    end
  end

  def to_dl(hash)
    out = "<dl>\n"
    hash.each do |key, val|
      out << "<dt>#{key}</dt>\n"
      dd = to_html(val)
      out << "<dd>#{dd}</dd>\n"
    end
    out << "</dl>\n"

    out
  end

  def to_ul(array)
    out = "<ul>\n"
    array.each do |item|
      li = to_html(item)
      out << "<li>#{li}</li>\n"
    end
    out << "</ul>\n"

    out
  end

  def to_anchor(str)
    str.downcase.gsub(/[^a-z0-9]+/, '-').sub(/^-|-$/, '')
  end

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

  def url(url_str)
    url_str.sub(%r{^https?://(www\.)?}, '')
  end

  # https://stackoverflow.com/a/1904193/358804
  def years_since(date)
    delta = (Date.today - date) / 365
    delta.ceil
  end

  def skill_years
    results = Hash.new(0)
    JOBS.each do |job|
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

  def skills(num_years_range)
    # TODO: don't recompute every time
    results = skill_years.select { |_skill, yrs| num_years_range.include?(yrs) }.keys
    results.sort_by!(&:downcase)
    results
  end
end

get %r{/(index)?} do
  respond_to do |wants|
    wants.html { erb :index }
    wants.json { PROFILE_STR }
  end
end

get '/index.json' do
  content_type 'application/json'
  PROFILE_STR
end

get '/meet' do
  erb :meet
end

get '/resume' do
  erb :resume
end

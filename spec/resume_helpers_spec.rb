require "active_support"
require "active_support/core_ext/object/blank"
require "hashie"
require "json"
require_relative "../helpers/resume_helpers"
require_relative "../helpers/time_helpers"

class TestableResumeHelpers
  include TimeHelpers
  include ResumeHelpers

  def data
    resume = JSON.load_file("data/resume.json")
    Hashie::Mash.new({resume: resume})
  end
end

RSpec.describe ResumeHelpers do
  before { @helper = TestableResumeHelpers.new }

  describe "#skills" do
    it "returns all skills for a full range" do
      jobs = @helper.all_jobs
      skills = @helper.skills(jobs, 0..100)
      all_skills = jobs.map(&:skills).flatten.uniq.compact

      expect(skills).to match_array(all_skills)
    end
  end
end

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

  describe "#skill_years" do
    it "sums the years for skills" do
      jobs = [
        Hashie::Mash.new({
          start_date: "2019-01-01",
          end_date: "2020-01-01",
          skills: ["foo", "bar"]
        }),
        Hashie::Mash.new({
          start_date: "2020-01-01",
          end_date: "2021-01-01",
          skills: ["foo"]
        })
      ]

      expect(@helper.skill_years(jobs)).to eq({
        "foo" => 2,
        "bar" => 1
      })
    end

    it "rounds up" do
      jobs = [
        Hashie::Mash.new({
          start_date: "2019-01-01",
          end_date: "2019-06-01",
          skills: ["foo"]
        })
      ]

      expect(@helper.skill_years(jobs)).to eq({"foo" => 1})
    end
  end

  describe "#skills" do
    it "returns all skills for full range" do
      jobs = @helper.all_jobs
      skills = @helper.skills(jobs, 0..100)
      all_skills = jobs.map(&:skills).flatten.uniq.compact

      expect(skills).to match_array(all_skills)
    end

    it "includes jobs in range" do
      skills = ["foo", "bar"]
      jobs = [
        Hashie::Mash.new({
          start_date: "2019-01-01",
          end_date: "2020-01-01",
          skills: skills
        })
      ]

      expect(@helper.skills(jobs, 0..1)).to match_array(skills)
    end

    it "excludes jobs out of range" do
      jobs = [
        Hashie::Mash.new({
          start_date: "2019-01-01",
          end_date: "2020-01-01",
          skills: ["foo", "bar"]
        })
      ]

      expect(@helper.skills(jobs, 2..3)).to eq([])
    end
  end
end

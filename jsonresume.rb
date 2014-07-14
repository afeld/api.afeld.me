require 'json'

json = JSON.parse(File.read('views/index.json'))

name = json['name'].split
um = json['education'][0]

resume = {
  bio: {
    firstName: name[0],
    lastName: name[1],
    email: {
      personal: json['email']
    },
    location: {
      city: json['location']['city'],
      state: json['location']['state'],
      countryCode: json['location']['country']
    },
    websites: {
      api: json['url'],
      blog: json['profiles']['jux']['profile_url']
    },
    profiles: {
      twitter: json['profiles']['twitter']['username'],
      github: json['profiles']['github']['username']
    }
  },
  work: [],
  education: [
    {
      institution: um['school'],
      # TODO PR to support multiple degrees
      area: 'BSE Computer Science Engineering',
      studyType: 'BFA Dance',
      startDate: um['start_date'],
      endDate: um['end_date']
    }
  ],
  skills: [
    {
      name: "Front-end",
      keywords: [
        "HTML/CSS",
        "JavaScript",
        "Backbone.js"
      ]
    },
    {
      name: "Back-end",
      keywords: [
        "Ruby",
        "Rails",
        "Node.js"
      ]
    }
  ]
}

jobs = json['employment']['coding'] + json['employment']['teaching']

# sort by jobs by last ended, then by last started, in descending order
jobs.sort_by! do |job|
  end_date = job['end_date'] || Time.now.strftime('%Y-%m-%d')
  [end_date, json['start_date']]
end
jobs.reverse!

jobs.each do |empl|
  hsh = {
    company: empl['organization'],
    position: empl['title'],
    website: empl['url'],
    startDate: empl['start_date'],
    summary: empl['description']
  }
  hsh[:endDate] = empl['end_date'] if empl['end_date']
  resume[:work] << hsh
end

File.open('resume.json', 'w') do |file|
  file.write(JSON.pretty_generate(resume))
end

`resume export resume.html`

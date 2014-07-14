require 'json'

json = JSON.parse(File.read('views/index.json'))

name = json['name'].split

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
  work: []
}

json['employment']['coding'].each do |empl|
  resume[:work] << {
    company: empl['organization'],
    position: empl['title'],
    website: empl['url'],
    startDate: empl['start_date'],
    endDate: empl['end_date'],
    summary: empl['description']
  }
end

File.open('resume.json', 'w') do |file|
  file.write(JSON.pretty_generate(resume))
end

`resume export resume.html`

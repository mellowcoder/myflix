Fabricator(:invite) do
  email {Faker::Internet.email}
  name {Faker::Name.name}
  message {Faker::Lorem.paragraph}
  user
end


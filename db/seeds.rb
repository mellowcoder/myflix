# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

comedy = Category.create({name: 'TV Comedies'})
drama = Category.create({name: 'TV Dramas'})

3.times do |num|
  Video.create([{title: "South Park #{num}", description: 'South Park is an American adult animated sitcom created by Trey Parker and Matt Stone for the Comedy Central television network.',
               category: comedy},
              {title: "Family Guy #{num}", description: 'Family Guy is an American adult animated sitcom created by Seth MacFarlane for the Fox Broadcasting Company',
               category: comedy},
              {title: "Futurama #{num}",  description: 'Futurama is an American adult animated science fiction sitcom created by Matt Groening and developed by Groening and David X. Cohen for the Fox Broadcasting Company',
               category: comedy},
              {title: "Monk #{num}",  description: 'Monk is an American comedy-drama detective mystery television series created by Andy Breckman and starring Tony Shalhoub as the eponymous character, Adrian Monk.',
               category: drama}])
end

ebert = User.create(email: 'rebert@critics.com', full_name: 'Roger Ebert', password: 'secret')
shatner = User.create(email: 'wshatner@stars.com', full_name: 'William Shatner', password: 'secret')
doe = User.create(email: 'jdoe@public.com', full_name: 'John Doe', password: 'secret')

futurama1 = Video.search_by_title("Futurama 1").first
futurama2 = Video.search_by_title("Futurama 2").first

Review.create(video: futurama1, user: ebert, rating: 2, content: "This is the text of the first review. Critics panned this episode.")
Review.create(video: futurama1, user: shatner, rating: 5, content: "This is the text of the second review.  William Shatner loves Futurama")
Review.create(video: futurama1, user: doe, rating: 4, content: "This is the text of the last review. The general public enjoyed it.")

monk1 = Video.search_by_title("Monk 1").first
monk2 = Video.search_by_title("Monk 2").first

QueueItem.create(video: futurama2, user: ebert, position: 1)
QueueItem.create(video: monk2, user: ebert, position: 2)
QueueItem.create(video: futurama1, user: shatner, position: 1)
QueueItem.create(video: monk1, user: shatner, position: 2)

Relationship.create(follower: shatner, followed: ebert)
Relationship.create(follower: shatner, followed: doe)
Relationship.create(follower: doe, followed: ebert)
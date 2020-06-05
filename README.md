#### Run
- clone the repo
- `cd rest_reserv_sketch/`
- `rvm use ruby-2.5.7` or `rbenv local 2.5.7`
- `bundle install`
- `rake db:create db:migrate`
- `rspec spec`


--------


#### Comments
- I am not very happy with my time arithmetic. I'm sure there should be more convenient and straightforward way to do this _without_ using all those coercions and transformations between time's data.

- It would be nice to add custom errors with more descriptive messages (e.g. instead of `should match restaurant schedule` it might be something like: `does not match restaurant schedule, a reservation may be made on or after 11:30.`)

- For a real-world application there also a need to manage time zone issues.

- At the moment, if a reservation overlaps with another reservation for the same table it will be restricted (cannot be created) - it might be better to move the reservation to the nearest free time (e.g. table is reserved for 12:00-13:00 by a user A and a user B wants the very same table to be reserved for 12:30-14:00, so, we can move their reservation to 13:00-14:00 instead of restrict it completely). The same is for restaurant's schedule - fit into schedule instead of decline.




--------

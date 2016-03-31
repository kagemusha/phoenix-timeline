# PhoenixTimeline WIP

This is the server component of an implementation of the game [Timeline]((http://www.amazon.com/Timeline-Historical-Events-Card-Game/dp/2914849869/ref=pd_sim_21_1?ie=UTF8&dpID=51i4IfOEIaL&dpSrc=sims&preST=_AC_UL160_SR141%2C160_&refRID=1WXSN1GDK2BMAZ2WXTQ0).  
It runs in tandem with its [companion Ember.js client](https://github.com/kagemusha/timeline)

## Running the App

  * (you need to have [Postgres](http://www.postgresql.org/) installed)

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

  * Start the [Ember client](https://github.com/kagemusha/timeline)

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: http://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

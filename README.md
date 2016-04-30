# PhoenixTimeline WIP

This is the server component of an implementation of the game [Timeline](http://www.amazon.com/Timeline-Historical-Events-Card-Game/dp/2914849869/ref=pd_sim_21_1?ie=UTF8&dpID=51i4IfOEIaL&dpSrc=sims&preST=_AC_UL160_SR141%2C160_&refRID=1WXSN1GDK2BMAZ2WXTQ0).  
It runs in tandem with its [companion Ember.js client](https://github.com/kagemusha/timeline)

## Running the App

  1. Install Postgres
  
     See the [Postgres Installation Guide](https://wiki.postgresql.org/wiki/Detailed_installation_guides). If you're on 
     Mac, [Postgress.app](http://postgresapp.com/) is another easy option.

     The default database configuration in `config/dev.exs` should work (username of `postgres`, password 
     shouldn't matter).  
     
     If you want to create a new user (role), use the command:
     
         > createuser -d someUserName --pwprompt
         
     the `-d` option gives this role database create rights and you will be prompted for a password.  After the role has been created, edit the database `username` and `password` fields in `config/dev.exs file`
     
  2.  Install dependencies 
  
          phoenix-timeline> mix deps.get

  3.  Create and migrate your database
  
          phoenix-timeline> mix ecto.create && mix ecto.migrate
  
  4.  Start the server 
  
          phoenix-timeline> mix phoenix.server

  5.  Install and start the [Timeline Ember client](https://github.com/kagemusha/timeline) as instructed there

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: http://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix


## The Domain Model

    Game
      has-many players
      has-many cards
      has-many turns
      belongs-to creator (player)
      belongs-to winner (player)
        
    Player
      belongs-to game
      has-many turns
        
      (has-one user)
        (as some point Player will be a relation btw game and user. So a real person
         would be a User who be multiple players each in a 1-to-1 relationship to a game)
     
    Card
     
    Turn
      belongs-to player
      belongs-to card
      belongs-to game 
      

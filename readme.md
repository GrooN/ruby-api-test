CH Application Assignment
==========

A simple demonstration showing how a REST/JSON API can be implemented in Ruby, and used by a JavaScript application written in AngularJS.

Links
-----
* [Heroku Client URL](http://stormy-hamlet-6016.herokuapp.com/client)
* [Git repository](https://github.com/groon/ruby-api-test)

Usage
-----
__Fetch companies from database__

    curl -X GET http://stormy-hamlet-6016.herokuapp.com/company -i

__Fetch single company from database with id of 1__

    curl -X GET http://stormy-hamlet-6016.herokuapp.com/company/1 -i

__Add a new company to the database__

    curl -X POST -d '{"name": "my company", "address": "my address", "city": "my city", "country": "my country"}' http://stormy-hamlet-6016.herokuapp.com/company -i

__Update existing company__

Remember to include __company_id__ in query

    curl -X PUT -d '{"company_id":1, "name": "New name"}' http://stormy-hamlet-6016.herokuapp.com/company -i

Authentication
--------
One could add authentication by including an API Token in every request, which would identify the specific user. One token for each user. This combined with sending data via HTTPS would add a relatively simple but stable authentication layer to the process.

Another approach could be to handle authentication via cookies, like done on most normal websites. This would require the client to authenticate via password before being able to use the API, afterwards the user must send the cookie in every request.

Database with version control
----------
Firstly one should keep changes documented. Secondly when changes are made, make them in seperate script files, and add version control to each script, this way it is possible to go back to previous db schemes, store procedures and the like if necessary.
Summary
=======

Authenticator is a web service that allows you to easily
implement a very secure and robust authentication system into your application.  It provides a fully
RESTful API using XML over HTTP and is secured using HTTP Basic Authentication.  This document
describes how to interact with the Authenticator service using cURL and ActiveRecord.

Throughout this document, you will see code examples.  There will always be two, first a cURL 
example, followed by an ActiveResource example.

    How to interact with Authenticator using cURL

    How to interact with Authenticator using ActiveResource
	

Site Domain and API Key
=======================

In order to incorporate Authenticator into your application, you will first need a valid 
domain and API key, such as:

Domain: `capansis.com`

API Key: `c144dccfa6d57711185083fb0336dcfa9b33ac61`

These credentials can then be used as a username and password with HTTP Basic Authentication to 
interface your application with the authentication service.

    http(s)://capansis.com:c144dccfa6d57711185083fb0336dcfa9b33ac61@authentication.capansis.net

    self.site     = "http(s)://authentication.capansis.net"
    self.user     = "capansis.com"
    self.password = "c144dccfa6d57711185083fb0336dcfa9b33ac61"

Making Requests
===============

Requests to the authentication service are made via URLs and HTTP verbs.  The URL represents a
resource within the authentication service (e.g. an account), while the HTTP verb describes method
to interact with it (e.g. retrieve, add, change or delete).  There are four different verbs you can
use to interact with the authentication service.

__Get__: Retrieves a object or collection of objects from the authentication service, such as a users
account.

__Post__: Adds a new object to the system, such as registering a new user or logging an existing user
into the system.

__Put__: Changes an existing object within the system, such as a user updating their email address or
changing their password.

__Delete__: Removes an object from the system.

These methods are used to interact with two objects via the API.

Account
-------

Represents the account for a user.  An account contains the users email address and encrypted
password.

Login
-----

Represents the authenticated session for a user.  A login contains the time and date that a user
successfully authenticated via the service.

Accounts
========

There are seven ways to interact with the Account resource API.

Getting a Collection of Accounts
--------------------------------

To get a full collection of accounts, filtered by the first letter in an accounts email address,
pass a GET request to the Accounts resource with the letter parameter.

    curl -X GET -i -u domain:api_key http(s)://authentication.capansis.com/accounts.xml?letter=a

    Account.find(:all, :params => {:letter => "a"})

__NOTE__:

If no letter parameter is given, Authenticator will default to the letter "a".

Getting a Single Account
------------------------

To get a single account, pass a GET request to an Accounts resource member.

    curl -X GET -i -u domain:api_key http(s)://authentication.capansis.com/accounts/12345.xml

    Account.find(12345)

Creating a New Account
----------------------

To create a new account, pass a POST request to the Accounts resource with properly formated account
data.

    curl -X POST -i -u domain:api_key \
    -d "account[email_address]=name@domain.com&account[password]=password&account[password_confirmation]=password" \
    http(s)://authentication.capansis.com/accounts.xml

    @account = Account.new(params[:account])
    @account.save

If the new account can be created, the authentication service will return the XML representation of
the account.

If the new account cannot be created, the authentication service will return an HTTP 422
Unprocessable Entity code and an XML representation of the errors.

After successful creation, the authentication service will send a verification letter to the email
address registered.  This letter will include a verification link, that once clicked, will activate
the account and log the user into the system.

__NOTE__:

Users will not be able to login through the authentication service until their account is activated.

Verifying an Accounts Email Address
-----------------------------------

To activate or recover an account, pass a PUT request to an Accounts resource member with a
verification key.

    curl -X PUT -i -u domain:api_key http(s)://authentication.capansis.net/accounts/12345.xml?verification_key=6a57a7d7430418b3fb579c9c7558ec2719aa9edb37b6940a381d72af16c3619e

    @account = Account.find(12345)
    @account.put(:verify, :verification_key => "6a57a7d7430418b3fb579c9c7558ec2719aa9edb37b6940a381d72af16c3619e")

If the account and verification key are valid, the authentication service will return a HTTP 200 OK.
Otherwise, it will return a HTTP 404 Not Found.

__NOTE__:

You can check if the Account is being activated or recovered by checking the activated attribute.
This is helpful if you want activating users to be redirected to a "Home" page, while recovering
users to be redirected to a "Change Password" page.

    # Example using ActiveResource
  
    # If the verification is for an activation
    @account.activated? => false
    # If the verification is for a recovery
    @account.activated? => true

Updating an Existing Account
----------------------------

To update account, pass a PUT request to an Accounts resource member with properly formatted account
data.

    curl -X PUT -i -u domain:api_key \
    -d "account[email_address]=name@domain.com&account[password]=password&account[password_confirmation]=password" \
    http(s)://authentication.capansis.com/12345/accounts.xml

    @account = Account.find(12345).load(params[:account])
    @account.save

If the account can be updated, the authentication service will return the XML representation of the
account.

If the account cannot be updated, the authentication service will return an HTTP 422 Unprocessable
Entity code and an XML representation of the errors.

Recovering an Existing Account
------------------------------

To have a recovery letter with verification link sent to an account owners email address of record,
pass a POST request to the Accounts resource with an email address.

    curl -X POST -i -u domain:api_key -d "email_address=name@domain.com" http(s)://authentication.capansis.net/accounts/recover.xml

    Account.post(:recover, :email_address => name@domain.com)

If the account can be found, the authentication service will send an email to the address on record,
thus allowing the account owner to login via the verify action.

Logins
======

There is one way to interact with the Account resource API.

Creating a new Login
--------------------

To verify an accounts credentials and create a new Login, pass a POST request to the Logins resource
with properly formated login data.

    curl -X POST -i -u domain.com:api_key -d "login[email_address]=name@domain.com&login[password]=secret" http(s)://authentication.capansis.net/logins.xml

    @login = Login.new(params[:login])
    @login.save
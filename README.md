# Base Project

An opinionated starter repo. If you find a bug please submit a pull-request.

## Asset pipeline changes

* Removed coffee script from the asset pipeline. I like it but for some reason I feel much comfortable with plain old js in my projects.
* 2 manifest files one for the public site *application.[js|css]* and another one for the admin section *admin.[js|css]*.
    * The manifests do not require_tree only specific files. I prefferr to manually include what I'm using.
* [bootstrap-rails](https://github.com/anjlab/bootstrap-rails) using version 3.0.
* [quiet-assets](https://github.com/evrone/quiet_assets) for development.

## Views

* [Haml](http://haml.info/) & [HamlRails](https://github.com/indirect/haml-rails).
* [SimpleForm](https://github.com/plataformatec/simple_form).

## Pagination

* [will-paginate](https://github.com/mislav/will_paginate).

## Seeds

* [Seedbank](https://github.com/james2m/seedbank), allows to separate seeds in different files per environment and adds dependencies between seeds files.

## Authentication

* [Sorcery](https://github.com/NoamB/sorcery) for authentication. Based on a [Ryan Bates Railscast](http://railscasts.com/episodes/283-authentication-with-sorcery).
* Already set up some useful controllers:
    * HomeController: Public controller
    * AdminController: Base class for administration controllers. I try to group all the admin specific controller methods here
    * DashboardController: Private controller extending AdminController

## Authorization

Home made authorization

* The User model has a role column; the column can be 'user' or 'admin' (actually it can be anything you want).
* User instances responding true to the admin? method are admins, yey!
* The AdminController has two before filter:

 ```ruby
 class AdminController < ApplicationController

   before_filter :require_login #provided by sorcery
   before_filter :require_admins
   layout "admin"

   private

   def require_admins
     redirect_to root_url, notice: I18n.t("auth.not_allowed") unless current_user.admin?
   end

 end
 ```

## User extra attributes

For convenience a UserInfo (User <-> UserInfo) model has been created. The intention of this new model is to pull out from the User class all extra attributes that are not necessary for authentication / authorization.
Use UserInfo every time you need to store data from a user like first name, last name, phone, etc.

## Testing

* Old good [rspec](https://www.relishapp.com/rspec/rspec-rails) for testing.

## I18n

All translations are in spanish because that's the language I use.

## To do

* Specs for views
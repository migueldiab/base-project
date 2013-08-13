# Base Project

An opinionated starter repo. If you find a bug please submit a pull-request.

## Asset pipeline changes

* Removed cofee script from the asset pipeline. I like it but for some reason I feel much comfortable with plain old js in my projects.
* 2 manifest files one for the public site *application.[js|css]* and another one for the admin section *admin.[js|css]*.
    * The manifests do not require_tree only specific files. I prefferr to manually include what I'm using.
* [bootstrap-rails](https://github.com/anjlab/bootstrap-rails) using version 3.0.
* [quiet-assets](https://github.com/evrone/quiet_assets) for development.

## Views

* [Haml](http://haml.info/) & [HamlRails](https://github.com/indirect/haml-rails).
* [SimpleForm](https://github.com/plataformatec/simple_form).

## Pagination

* [will-paginate](https://github.com/mislav/will_paginate).

## Authentication

* [Sorcery](https://github.com/NoamB/sorcery) for authentication. Based on a [Ryan Bates Railscast](http://railscasts.com/episodes/283-authentication-with-sorcery).
* Already set up some usefull controllers:
    * HomeController: Public controller
    * AdminController: Base class for administration controllers. I try to group all the admin specific controller methods here
    * DashboardController: Private controller extending AdminController


## Testing

* Old good [rspec](https://www.relishapp.com/rspec/rspec-rails) for testing.

## I18n

All translations are in spanish because that's the language I use.

## To do

* Follow the sorcery guides to add password reset
* Create a separate branch for authorization (cancan or custom?)
* Add controller specs for login / logout / remember me / register
# Redmine KPT Plugin

Do Keep/Problem/Try method at Redmine project.

Supported Redmine 2.2.x, 2.3.0.

## Installation

A. Copy the plugin into the Redmine plugins directory.

B. Migrations, rake task are available.

    bundle exec rake redmine:kpt:install RAILS_ENV=production

C. Restart Redmine and set permissions at *Roles and Permissions* administrator menu.

D. Enable KPT module in a project settings.

## Uninstallation

Do following task if you want to drop KPT data from DB.

    bundle exec rake redmine:kpt:uninstall RAILS_ENV=production

And remove redmine\_kpt directory.


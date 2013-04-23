# Redmine KPT Plugin

Do Keep/Problem/Try method at Redmine project.

Supported Redmine 2.2.x, 2.3.0.

## Installation

A. Copy this plugin into Redmine/plugins directory.

B. Migrations, rake task are available.

    bundle exec rake redmine:kpt:install RAILS_ENV=production

C. Restart Redmine and setup permissions at *Roles and Permissions* administrator menu.

D. Enable KPT module in a project settings.

## Uninstallation

Following task is drop all KPT data.

    bundle exec rake redmine:kpt:uninstall RAILS_ENV=production

Remove redmine\_kpt directory.


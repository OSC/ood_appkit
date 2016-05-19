## Develop

Generated using:

    rails plugin new osc_machete_rails --full --skip-bundle

## Usage

### URL Handlers for System Apps

#### Dashboard URL

```ruby
# access dashboard url for the link "back to dashboard"
OodApp.dashboard.url # /pun/sys/dashboard
```

You can change the base url using `OOD_DASHBOARD_URL` env var or modifying the
configuration in an initializer:

```ruby
# config/initializers/ood_app.rb

OodApp.configure do |config|
  config.dashboard = OodApp::DashboardUrl.new base_url: '/pun/sys/dashboard'
end
```

#### Files App

```ruby
# url to launch files app
OodApp.files.url

# url to open files app to specified directory (accepts any object with `#to_s`)
OodApp.files.url(path: "/nfs/17/efranz/ood_dev")
OodApp.files.url(path: Pathname.new("/nfs/17/efranz/ood_dev"))

# url to retrieve API information for specified path
OodApp.files.api(path: "/nfs/17/efranz/ood_dev")
```

You can change the base url using `OOD_FILES_URL` env var or modifying the
configuration in an initializer:

```ruby
# config/initializers/ood_app.rb

OodApp.configure do |config|
  config.files = OodApp::FilesUrl.new base_url: '/pun/sys/files'
end
```

#### Shell App

```ruby
# url to launch shell app
OodApp.shell.url

# url to launch shell app for specified host
OodApp.shell.url(host: "ruby")

# url to launch shell app in specified directory
OodApp.shell.url(path: "/nfs/17/efranz/ood_dev")

# url to launch shell app for specified host in directory
OodApp.shell.url(host: "ruby", path: "/nfs/17/efranz/ood_dev")
```

You can change the base url using `OOD_SHELL_URL` env var or modifying the
configuration in an initializer:

```ruby
# config/initializers/ood_app.rb

OodApp.configure do |config|
  config.shell = OodApp::ShellUrl.new base_url: '/pun/sys/shell'
end
```

### Rack Middleware for handling Files under Dataroot

This automounts all the files under the `OodApp.dataroot` using the following route by default:

```ruby
# config/routes.rb

mount OodApp.files_rack_app => '/files', as: 'files'
```

To alter this behavior modify the configuration in an initializer as such:

```ruby
# config/initializers/ood_app.rb

OodApp.configure do |config|
  config.files_rack_app = OodApp::FilesRackApp.new route_path: '/files', route_helper: 'files'

  # To disable this route completely, uncomment the line below
  #config.files_rack_app = nil
end
```

### Markdown Handler

A simple markdown handler is included with this gem. Any views with the
extensions `*.md` or `*.markdown` will be handled using the `Redcarpet` gem.
The renderer can be modified as such:

```ruby
# config/initializers/ood_app.rb

OodApp.configure do |config|
  config.markdown = Redcarpet::Markdown.new(
    Redcarpet::Render::HTML,
    autolink: true,
    tables: true,
    strikethrough: true,
    fenced_code_blocks: true,
    no_intra_emphasis: true
  )
end
```

Really any object can be used that responds to `#render`.

Note: You will need to import the appropriate stylesheet if you want the
rendered markdown to resemble GitHub's display of markdown.

```scss
// app/assets/stylesheets/application.scss

import "ood_app/markdown";
```

It is also included if you import the default stylesheet:


```scss
// app/assets/stylesheets/application.scss

import "ood_app";
```

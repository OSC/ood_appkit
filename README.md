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

This mounts all the files under the `OodApp.dataroot` using the following route
by default:

```ruby
# config/routes.rb

mount OodApp::FilesRackApp.new => '/files', as: :files
```

To disable this generated route:

```ruby
# config/initializers/ood_app.rb

OodApp.configure do |config|
  config.routes.files_rack_app = false
end
```

To add a new route:

```ruby
# config/routes.rb

# rename URI from '/files' to '/dataroot'
mount OodApp::FilesRackApp.new => '/dataroot', as: :files

# create new route with root set to '/tmp' on filesystem
mount OodApp::FilesRackApp.new(root: '/tmp') => '/tmp', as: :tmp
```

### Wiki Static Page Engine

This gem comes with a wiki static page engine. It uses the supplied markdown
handler to display GitHub style wiki pages.

By default the route is generated for you:

```ruby
# config/routes.rb

get 'wiki/*page' => 'ood_app/wiki#show', as: :wiki, content_path: 'wiki'
```

and can be accessed within your app by

```erb
<%= link_to "Documentation", wiki_path('Home') %>
```

To disable this generated route:

```ruby
# config/initializers/ood_app.rb

OodApp.configure do |config|
  config.routes.wiki = false
end
```

To change (disable route first) or add a new route:

```ruby
# config/routes.rb

# can modify URI as well as file system content path where files reside
get 'tutorial/*page' => 'ood_app/wiki#show', as: :tutorial, content_path: '/path/to/my_tutorial'

# can use your own controller
get 'wiki/*page' => 'my_wiki#show', as: :wiki, content_path: 'wiki'
```

You can use your own controller by including the appropriate concern:

```ruby
# app/controllers/my_wiki_controller.rb
class MyWikiController < ApplicationController
  include OodApp::WikiPage

  layout :layout_for_page

  private
    def layout_for_page
      'wiki_layout'
    end
end
```

And add a show view for this controller:

```erb
<%# app/views/my_wiki/show.html.erb %>

<div class="ood_app markdown">
  <div class="row">
    <div class="col-md-8 col-md-offset-2">
      <%= render file: @page %>
    </div>
  </div>
</div>
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

@import "ood_app/markdown";
```

It is also included if you import the default stylesheet:


```scss
// app/assets/stylesheets/application.scss

@import "ood_app";
```

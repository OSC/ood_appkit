## Installation

To use, add this line to your application's Gemfile:

    gem 'ood_appkit'

And then execute:

    bundle install

## Usage

### Rake Tasks

#### reset

Running this rake task

```bash
bin/rake ood_appkit:reset
```

will clear the Rails cache and update the timestamp on the `tmp/restart.txt`
file that is used by Passenger to decide whether to restart the application.

### URL Handlers for System Apps

#### Public URL

This is the URL used to access publicly available assets provided by the OOD
infrastructure, e.g., the `favicon.ico`.

```erb
<%= favicon_link_tag nil, href: OodAppkit.public.url.join('favicon.ico') %>
```

Note: We used `nil` here as the source otherwise Rails will try to prepend the
`RAILS_RELATIVE_URL_ROOT` to it. We explicitly define the link using `href:`
instead.

You can change the options using environment variables:

```bash
OOD_PUBLIC_URL='/public'
OOD_PUBLIC_TITLE='Public Assets'
```

Or by modifying the configuration in an initializer:

```ruby
# config/initializers/ood_appkit.rb

OodAppkit.configure do |config|
  # Defaults
  config.public = OodAppkit::PublicUrl.new title: 'Public Assets', base_url: '/public'
end
```

#### Dashboard URL

```erb
<%= link_to OodAppkit.dashboard.title, OodAppkit.dashboard.url.to_s %>
```

You can change the options using environment variables:

```bash
OOD_DASHBOARD_URL='/pun/sys/dashboard'
OOD_DASHBOARD_TITLE='Dashboard'
```

Or by modifying the configuration in an initializer:

```ruby
# config/initializers/ood_appkit.rb

OodAppkit.configure do |config|
  # Defaults
  config.dashboard = OodAppkit::DashboardUrl.new title: 'Dashboard', base_url: '/pun/sys/dashboard'
end
```

#### Files App

```erb
<%# Link to the Files app %>
<%= link_to OodAppkit.files.title, OodAppkit.files.url.to_s %>

<%# Link to open files app to specified directory %>
<%= link_to "/path/to/file", OodAppkit.files.url(path: "/path/to/file").to_s %>
<%= link_to "/path/to/file", OodAppkit.files.url(path: Pathname.new("/path/to/file")).to_s %>

<%# Link to retrieve API info for given file %>
<%= link_to "/path/to/file", OodAppkit.files.api(path: "/path/to/file").to_s %>
```

You can change the options using environment variables:

```bash
OOD_FILES_URL='/pun/sys/files'
OOD_FILES_TITLE='Files'
```

Or by modifying the configuration in an initializer:

```ruby
# config/initializers/ood_appkit.rb

OodAppkit.configure do |config|
  # Defaults
  config.files = OodAppkit::FilesUrl.new title: 'Files', base_url: '/pun/sys/files'
end
```

#### File Editor App

```erb
<%# Link to the Editor app %>
<%= link_to OodAppkit.editor.title, OodAppkit.editor.url.to_s %>

<%# Link to open file editor app to edit specific file %>
<%= link_to "Edit /path/to/file", OodAppkit.editor.edit(path: "/path/to/file").to_s %>
<%= link_to "Edit /path/to/file", OodAppkit.editor.edit(path: Pathname.new("/path/to/file")).to_s %>
```

You can change the options using environment variables:

```bash
OOD_EDITOR_URL='/pun/sys/file-editor'
OOD_EDITOR_TITLE='EDITOR'
```

Or by modifying the configuration in an initializer:

```ruby
# config/initializers/ood_appkit.rb

OodAppkit.configure do |config|
  # Defaults
  config.editor = OodAppkit::EditorUrl.new title: 'Editor', base_url: '/pun/sys/file-editor'
end
```

#### Shell App

```erb
<%# Link to the Shell app %>
<%= link_to OodAppkit.shell.title, OodAppkit.shell.url.to_s %>

<%# Link to launch Shell app for specified host %>
<%= link_to "Ruby Shell", OodAppkit.shell.url(host: "ruby").to_s %>

<%# Link to launch Shell app in specified directory %>
<%= link_to "Shell in /path/to/dir", OodAppkit.shell.url(path: "/path/to/dir").to_s %>

<%# Link to launch Shell app for specified host in directory %>
<%= link_to "Ruby in /path/to/dir", OodAppkit.shell.url(host: "ruby", path: "/path/to/dir").to_s %>
```

You can change the options using environment variables:

```bash
OOD_SHELL_URL='/pun/sys/shell'
OOD_SHELL_TITLE='Shell'
```

Or by modifying the configuration in an initializer:

```ruby
# config/initializers/ood_appkit.rb

OodAppkit.configure do |config|
  # Defaults
  config.shell = OodAppkit::ShellUrl.new title: 'Shell', base_url: '/pun/sys/shell'
end
```

### Rack Middleware for handling Files under Dataroot

This mounts all the files under the `OodAppkit.dataroot` using the following route
by default:

```ruby
# config/routes.rb

mount OodAppkit::FilesRackApp.new => '/files', as: :files
```

To disable this generated route:

```ruby
# config/initializers/ood_appkit.rb

OodAppkit.configure do |config|
  config.routes.files_rack_app = false
end
```

To add a new route:

```ruby
# config/routes.rb

# rename URI from '/files' to '/dataroot'
mount OodAppkit::FilesRackApp.new => '/dataroot', as: :files

# create new route with root set to '/tmp' on filesystem
mount OodAppkit::FilesRackApp.new(root: '/tmp') => '/tmp', as: :tmp
```

### Wiki Static Page Engine

This gem comes with a wiki static page engine. It uses the supplied markdown
handler to display GitHub style wiki pages.

By default the route is generated for you:

```ruby
# config/routes.rb

get 'wiki/*page' => 'ood_appkit/wiki#show', as: :wiki, content_path: 'wiki'
```

and can be accessed within your app by

```erb
<%= link_to "Documentation", wiki_path('Home') %>
```

To disable this generated route:

```ruby
# config/initializers/ood_appkit.rb

OodAppkit.configure do |config|
  config.routes.wiki = false
end
```

To change (disable route first) or add a new route:

```ruby
# config/routes.rb

# can modify URI as well as file system content path where files reside
get 'tutorial/*page' => 'ood_appkit/wiki#show', as: :tutorial, content_path: '/path/to/my_tutorial'

# can use your own controller
get 'wiki/*page' => 'my_wiki#show', as: :wiki, content_path: 'wiki'
```

You can use your own controller by including the appropriate concern:

```ruby
# app/controllers/my_wiki_controller.rb
class MyWikiController < ApplicationController
  include OodAppkit::WikiPage

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

<div class="ood-appkit markdown">
  <div class="row">
    <div class="col-md-8 col-md-offset-2">
      <%= render file: @page %>
    </div>
  </div>
</div>
```


### Override Bootstrap Variables

You can easily override any bootstrap variable using environment variables:

```bash
# BOOTSTRAP_<variable>='<value>'

# Change font sizes
BOOTSTRAP_FONT_SIZE_H1='50px'
BOOTSTRAP_FONT_SIZE_H2='24px'

# Re-use variables
BOOTSTRAP_GRAY_BASE='#000'
BOOTSTRAP_GRAY_DARKER='lighten($gray-base, 13.5%)'
BOOTSTRAP_GRAY_DARK='lighten($gray-base, 20%)'
```

The variables can also be overridden in an initializer:

```ruby
# config/initializers/ood_appkit.rb

OodAppkit.configure do |config|
  # These are the defaults
  config.bootstrap.navbar_inverse_bg = '#53565a'
  config.bootstrap.navbar_inverse_link_color = '#fff'
  config.bootstrap.navbar_inverse_color = '$navbar-inverse-link-color'
  config.bootstrap.navbar_inverse_link_hover_color = 'darken($navbar-inverse-link-color, 20%)'
  config.bootstrap.navbar_inverse_brand_color = '$navbar-inverse-link-color'
  config.bootstrap.navbar_inverse_brand_hover_color = '$navbar-inverse-link-hover-color'
end
```

You **MUST** import the bootstrap overrides into your stylesheets
for these to take effect

```scss
// app/assets/stylesheets/application.scss

// load the bootstrap sprockets first
@import "bootstrap-sprockets";

// this MUST occur before you import bootstrap
@import "ood_appkit/bootstrap-overrides";

// this MUST occur after the bootstrap overrides
@import "bootstrap";
```

### Markdown Handler

A simple markdown handler is included with this gem. Any views with the
extensions `*.md` or `*.markdown` will be handled using the `Redcarpet` gem.
The renderer can be modified as such:

```ruby
# config/initializers/ood_appkit.rb

OodAppkit.configure do |config|
  # Default
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

@import "ood_appkit/markdown";
```

It is also included if you import the default stylesheet:


```scss
// app/assets/stylesheets/application.scss

@import "ood_appkit";
```

### Custom Log Formatting

A custom log formatter is provided, along with lograge, to both reduce the
amount of unnecessary logging in production but properly prefix each log with
timestamp, log severity, and the name of the application. By default
`enable_log_formatter` is set to true for the production environment, but you
can turn it on all the time by using an initializer:

```ruby
# config/initializers/ood_appkit.rb

OodAppkit.configure do |config|
  # Default
  config.enable_log_formatter = true
end
```

This does several things things:

1. enable lograge
2. call `OodAppkit::LogFormatter.setup` which

    * sets the formatter of the Rails logger to an instance of OodAppkit::LogFormatter
    * and sets the `progname` of the Rails logger to the `APP_TOKEN` env var if it is set


In production, a single log will look like:

```
[2016-06-20 10:23:59 -0400 sys/dashboard]  "INFO method=GET path=/pun/dev/dashboard/ format=html controller=dashboard action=index status=200 duration=297.15 view=290.20"
```


## Branding Features

To take advantage of branding features you must import it in your stylesheet:

```scss
// app/assets/stylesheets/application.scss

@import "ood_appkit/branding";
```

It is also included if you import the default stylesheet:


```scss
// app/assets/stylesheets/application.scss

@import "ood_appkit";
```

### Navbar Breadcrumbs

One such branding feature is the `navbar-breadcrumbs`. It is used to accentuate
the tree like style of the app in the navbar. It is used as such:

```erb
<nav class="ood-appkit navbar navbar-inverse navbar-static-top" role="navigation">
  <div class="navbar-header">
    ...
    <ul class="navbar-breadcrumbs">
      <li><%= link_to OodAppkit.dashboard.title, OodAppkit.dashboard.url.to_s %></li>
      <li><%= link_to 'MyApp', root_path %></li>
      <li><%= link_to 'Meshes', meshes_path %></li>
    </ul>
  </div>

  ...
</nav>
```

Note that you must include `ood-appkit` as a class in the `nav` tag. The
breadcrumbs style will resemble the `navbar-brand` style.

### Cluster Information

A hash of available clusters is accessible from this gem through:

```ruby
# Hash of all available clusters
OodAppkit.clusters.all
#=> {
#     cluster1: <OodAppkit::Cluster ...>,
#     cluster2: <OodAppkit::Cluster ...>,
#     ...
#   }

# Hash of all available High Performance Computing (hpc) clusters
OodAppkit.clusters.hpc
#=> {
#     cluster1: <OodAppkit::Cluster ...>,
#     cluster2: <OodAppkit::Cluster ...>,
#     ...
#   }

# Hash of all available Low Performance Computing (hpc) clusters
# NB: A low performance computing cluster expects jobs that request a single
#     core and use minimal resources (e.g., a desktop for file browsing/editing,
#     a web server that submits jobs to an HPC cluster, visualization software)
OodAppkit.clusters.lpc
#=> {
#     cluster3: <OodAppkit::Cluster ...>,
#     cluster4: <OodAppkit::Cluster ...>,
#     ...
#   }
```

Each cluster object will have servers that the developer can communicate with
or link to:

```ruby
# Choose cluster from available list
my_cluster = OodAppkit.clusters.hpc[:cluster1]

# Check if it has a login server
my_cluster.login_server?
#=> true

# View all available servers
my_cluster.servers
#=> {
#     login: <OodAppkit::Server ...>,
#     resource_mgr: <OodAppkit::Servers::Torque ...>,
#     scheduler: <OodAppkit::Servers::Moab ...>,
#     ...
#   }

# Choose a particular server
login_server = my_cluster.login_server
```

Depending on the type of server chosen, different helper methods will be
available to the developer. For all servers the `host` will be available:

```ruby
# Choose a particular server
login_server = my_cluster.login_server

# Get host for this server
login_server.host
#=> "my_cluster.hpc_center.edu"
```

The Torque/Moab servers will also supply information for the clients used to
communicate with the servers

```ruby
# Get the Resource Manager server (known to be Torque at your HPC center)
torque_server = my_cluster.resource_mgr_server

# Get the path to the client library
torque_server.lib.to_s
#=> "/usr/local/torque/x.x.x/lib"

# Get the path to the client binaries
torque_server.bin.to_s
#=> "/usr/local/torque/x.x.x/bin"
```

Web servers will have a URI method to access the server

```ruby
# Get the Ganglia web server
ganglia_server = my_cluster.ganglia_server

# Get URI used to access this web server
ganglia_server.uri.to_s
#=> "https://www.ganglia.com/gweb/graph.php?c=MyCluster"

# To add query values as options for the server
ganglia_server.merge_query_values(g: 'cpu_report').to_s
#=> "https://www.ganglia.com/gweb/graph.php?c=MyCluster&g=cpu_report"
```

The hash of clusters generated by OodAppkit can be modified by supplying a
different config file through the environment variable `OOD_CLUSTERS`

```
OOD_CLUSTERS="/path/to/my/config.yml"
```

or by modifying the configuration in an initializer

```ruby
# config/initializers/ood_appkit.rb

OodAppkit.configure do |config|
  config.clusters.all = OodAppkit::Cluster.all(file: "/path/to/my/config.yml")
end
```

## Develop

Generated using:

    rails plugin new ood_appkit --full --skip-bundle


## License

This gem is released under the [MIT License](http://www.opensource.org/licenses/MIT).

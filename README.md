## Develop

Generated using:

    rails plugin new osc_machete_rails --full --skip-bundle

## Usage


### Dashboard

```ruby
# access dashboard url for the link "back to dashboard"
OodApp.dashboard.url # /pun/sys/dashboard
```

Can change base url using `OOD_DASHBOARD_URL` env var or modifying attrs directly on `OodApp.files` object

### Files

```ruby
# url to launch files app
OodApp.files.url

# url to open files app to specified directory (accepts any object with `#to_s`)
OodApp.files.url(path: "/nfs/17/efranz/ood_dev")
OodApp.files.url(path: Pathname.new("/nfs/17/efranz/ood_dev"))

# url to retrieve API information for specified path
OodApp.files.api(path: "/nfs/17/efranz/ood_dev")
```

Can change base url using `OOD_FILES_URL` env var or modifying attrs directly on `OodApp.files` object

### Shell

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

Can change base url using `OOD_SHELL_URL` env var or modifying attrs directly on `OodApp.shell` object

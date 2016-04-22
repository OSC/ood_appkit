## Develop

Generated using:

    rails plugin new osc_machete_rails --full --skip-bundle

## Usage


### Dashboard

```ruby
# access dashboard url for the link "back to dashboard"
OodApp.dashboard.url # /pun/sys/dashboard or OOD_DATAROOT env var or RAILS_DATAROOT
OodApp.dashboard.title # OSC OnDemand or OOD_DASHBOARD_TITLE env var
```

### Files

```ruby
# base url to the files app opened to the user's home directory
OodApp.files.url

# url to open files app to specified directory (accepts pathname)
OodApp.files.url(path: "/nfs/17/efranz/ood_dev")
OodApp.files.url(path: Pathname.new("/nfs/17/efranz/ood_dev"))


# other base url's
OodApp.files.base_api_url

# base url to append the directory you want to open the files app to
OodApp.files.base_fs_url
```

Can change base url using OOD_FILES_URL env var or modifying attrs directly on OodApp.files object

### Shell

```ruby
OodApp.shell.url

OodApp.shell.url(path: "/nfs/17/efranz/ood_dev")

OodApp.shell.url(host: "ruby")

OodApp.shell.url(host: "ruby", path: "/nfs/17/efranz/ood_dev")
```

Can change base url using OOD_SHELL_URL env var or modifying attrs directly on OodApp.shell object



## Develop

Generated using:

    rails plugin new osc_machete_rails --full --skip-bundle

## Usage


### Dashboard

```ruby
# access dashboard url for the link "back to dashboard"
OodApp.dashboard.url
```

### Files

```ruby
# base url to the files app opened to the user's home directory
OodApp.files.url

# url to open files app to specified directory (accepts pathname)
OodApp.files.url(directory: "/nfs/17/efranz/ood_dev")
OodApp.files.url(directory: Pathname.new("/nfs/17/efranz/ood_dev"))


# other base url's (deprecate these! use something else in place)
OodApp.files.api_url

# base url to append the directory you want to open the files app to
# FIXME: should this end in /?
OodApp.files.fs_url
```

### Shell

```ruby
OodApp.shell.url

OodApp.shell.url(directory: "/nfs/17/efranz/ood_dev")

OodApp.shell.url(host: "ruby")

OodApp.shell.url(host: "ruby", directory: "/nfs/17/efranz/ood_dev")
```



todo: dataroot pathname configuration etc.

todo: fix ood_breadcrumbs helper in awesim_rails to use ood_app
todo: add ood_breadcrumbs or ood_app:breadcrumbs (namespaced helper?)


Rails.application.routes.draw do
  if OodApp.files_rack_app
    mount OodApp.files_rack_app => OodApp.files_rack_app.route_path, as: OodApp.files_rack_app.route_helper
  end
end

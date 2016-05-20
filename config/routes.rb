Rails.application.routes.draw do
  # Route for a Rack::Directory middleware app
  if OodApp.routes.files_rack_app
    mount OodApp::FilesRackApp.new => '/files', as: :files
  end

  # Route for hosting GitHub style wiki
  if OodApp.routes.wiki
    get 'wiki/*page' => 'ood_app/wiki#show', as: :wiki, content_path: 'wiki'
  end
end

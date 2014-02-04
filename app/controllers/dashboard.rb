HomeioLite::App.controller :dashboard do
  get :index do
    render('dashboard/index')
  end
end
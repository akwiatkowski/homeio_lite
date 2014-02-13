HomeioLite::App.controller :dashboard do
  get :index do
    render('dashboard/index')
  end

  get :payload do
    @meas_types = MeasCache.all.to_a
    render 'dashboard/payload'
  end
end
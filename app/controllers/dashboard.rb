HomeioLite::App.controller :dashboard do
  get :index do
    Barista.compile_all!
    render('dashboard/index')
  end

  get :payload do
    @meas_types = MeasCache.all.to_a
    @measurements = Hash[@meas_types.collect { |m| [m.name, MeasCacheStorage[m.name].last ] }]

    render 'dashboard/payload'
  end
end
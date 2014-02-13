HomeioLite::App.controller :measurements do
  get :show, map: "/measurements/:name" do
    limit = (params[:limit] || 100).to_i

    m = MeasCacheStorage[params[:name]]
    @buffer = m.buffer_values_relative_time(0, limit)

    render 'measurements/cache'
  end
end
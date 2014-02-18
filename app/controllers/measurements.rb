HomeioLite::App.controller :measurements do
  get :show, map: "/measurements/:name" do
    limit = (params[:limit] || 100).to_i

    @meas_cache_storage = MeasCacheStorage[params[:name]]
    @buffer = @meas_cache_storage.buffer(0, limit)
    @meas_cache = @meas_cache_storage.ohm

    render 'measurements/cache'
  end
end
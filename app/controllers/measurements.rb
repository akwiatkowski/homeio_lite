HomeioLite::App.controller :measurements do
  get :show, map: "/measurements/:name" do
    limit = (params[:limit] || 100).to_i

    m = MeasCacheStorage[params[:name]]
    b = m.buffer_values_relative_time(0, limit)

    b.to_json
  end
end
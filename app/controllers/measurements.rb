HomeioLite::App.controller :measurements do
  get :show, map: "/measurements/:name" do
    m = MeasCacheStorage[params[:name]]
    b = m.buffer(0, (params[:limit] || 100).to_i)

    b.to_json
  end
end
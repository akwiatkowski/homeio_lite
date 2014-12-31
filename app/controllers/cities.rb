HomeIo::App.controller :cities do
  get :index, map: "/cities" do

    render 'cities/index'
  end
end
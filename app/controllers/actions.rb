HomeioLite::App.controller :actions do
  post :execute, map: "/actions/:name/execute", csrf_protection: false do
    a = ActionCacheStorage[params[:name]]
    @action_type = a.ohm
    if user.admin?
      @result = a.execute!
    end

    render 'actions/execute'
  end
end
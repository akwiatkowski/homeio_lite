HomeIo::App.controller :measurements do
  get :show, map: "/measurements/:name" do
    @limit = (params[:limit] || 200).to_i
    @page = params[:page].to_i
    # f
    @from = @page * @limit
    @to = @from + @limit

    @meas_cache_storage = MeasCacheStorage[params[:name]]
    @buffer = @meas_cache_storage.buffer(@from, @to)
    @meas_cache = @meas_cache_storage.ohm
    @time_to = Time.at(@meas_cache_storage.last_time) - @meas_cache.interval * @from
    @time_from = Time.at(@meas_cache_storage.last_time) - @meas_cache.interval * @to
    @max_page = (@meas_cache_storage.buffer_length.to_f / @limit.to_f).floor # because -1

    format_time_string = "%Y-%m-%d %H:%M:%S"
    @time_to = @time_to.strftime(format_time_string)
    @time_from = @time_from.strftime(format_time_string)

    render 'measurements/cache'
  end
end
if @snippet.present?
  json.(@snippet, :id, :content, :created_at)
end
json.html(render partial: "index.html.erb")
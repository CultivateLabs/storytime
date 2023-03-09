json.(@media, :id, :file_url, :user_id, :created_at)
json.html render(partial: "storytime/dashboard/media/media", locals: {media: @media}, formats: [:html])
class SanitizeExistingStorytimeSnippets < ActiveRecord::Migration[4.2]
  # Snippet content was previously stored unsanitized and rendered with `raw`,
  # allowing stored XSS. Re-run the sanitizer over every existing snippet so
  # rows created before the before_save callback are scrubbed too.
  def up
    return if Storytime.post_sanitizer.blank?

    Storytime::Snippet.reset_column_information
    Storytime::Snippet.find_each do |snippet|
      next if snippet.content.blank?

      cleaned = Storytime.post_sanitizer.call(snippet.content)
      next if cleaned == snippet.content

      snippet.update_columns(content: cleaned)
    end
  end

  def down
    # Sanitization is not reversible; stripped markup cannot be restored.
  end
end

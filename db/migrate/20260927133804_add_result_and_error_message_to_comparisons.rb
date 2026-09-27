class AddResultAndErrorMessageToComparisons < ActiveRecord::Migration[8.0]
  def change
    add_column :comparisons, :result, :json
    add_column :comparisons, :error_message, :text
  end
end

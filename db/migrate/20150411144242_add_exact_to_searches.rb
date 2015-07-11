class AddExactToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :is_exact, :boolean
  end
end

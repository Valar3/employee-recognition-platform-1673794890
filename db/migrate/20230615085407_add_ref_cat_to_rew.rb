class AddRefCatToRew < ActiveRecord::Migration[6.1]
  def change
    add_reference :rewards, :category, foreign_key: true
  end
end

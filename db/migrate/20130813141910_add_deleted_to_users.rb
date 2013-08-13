class AddDeletedToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.boolean :deleted, default: false
    end
  end
end

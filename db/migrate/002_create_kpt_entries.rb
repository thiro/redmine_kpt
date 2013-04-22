class CreateKptEntries < ActiveRecord::Migration
  def change
    create_table :kpt_entries do |t|
      t.integer  :kpt_board_id
      t.integer  :user_id
      t.integer  :kind,        :null => false, :default => 0
      t.string   :description, :null => false, :default => "", :limit => 150
      t.datetime :created_at
    end
    add_index :kpt_entries, :kpt_board_id
    add_index :kpt_entries, :user_id
    add_index :kpt_entries, :kind
    add_index :kpt_entries, :created_at
  end
end

class CreateKptBoards < ActiveRecord::Migration
  def change
    create_table :kpt_boards do |t|
      t.integer  :project_id,     :null => false
      t.string   :title,          :null => false, :limit => 80
      t.integer  :keeps_count,    :null => false, :default => 0
      t.integer  :problems_count, :null => false, :default => 0
      t.integer  :tries_count,    :null => false, :default => 0
      t.boolean  :locked,         :null => false, :default => false
      t.datetime :created_at
    end
    add_index :kpt_boards, :project_id
    add_index :kpt_boards, :created_at
  end
end

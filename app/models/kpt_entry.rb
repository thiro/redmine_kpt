class KptEntry < ActiveRecord::Base
  unloadable
  KEEP, PROBLEM, TRY = 0, 1, 2

  belongs_to :kpt_board
  belongs_to :user
  validate  :valid_locking_board, :valid_maximum_entries, :on => :create
  validates :description, :presence => true, :length => { :within => 2..150 }
  validates :kind, :presence => true, :inclusion => [KEEP, PROBLEM, TRY]
  attr_accessible :description
  after_create :count_up
  after_destroy :count_down

  def description=(src)
    write_attribute(:description, src.to_s.strip)
  end

  # go helper
  def kindname
    %w(keep problem try)[self.kind]
  end

  protected

  def count_up
    key = KptBoard.counter_key(self.kind)
    KptBoard.increment_counter(key, self.kpt_board.id) if key
  end

  def count_down
    key = KptBoard.counter_key(self.kind)
    KptBoard.decrement_counter(key, self.kpt_board.id) if key
  end

  def valid_locking_board
    errors[:base] << I18n.t(:error_kpt_board_closed) if kpt_board.locked?
  end

  def valid_maximum_entries
    errors[:base] << I18n.t(:error_kpt_entry_is_over) if kpt_board.count_of(self.kind) >= 100
  end
end

class KptBoard < ActiveRecord::Base
  unloadable
  belongs_to :project
  has_many :entries, :class_name => 'KptEntry', :dependent => :destroy, :include => :user,
           :order => KptEntry.arel_table[:created_at].asc
  validates :title, :presence => true, :length => { :within => 2..80 }
  attr_accessible :title

  def self.counter_key(code)
    {
      KptEntry::KEEP => :keeps_count,
      KptEntry::PROBLEM => :problems_count,
      KptEntry::TRY => :tries_count,
    }[code]
  end

  def count_of(code)
    read_attribute(self.class.counter_key(code))
  end

  def title=(src)
    write_attribute(:title, src.to_s.strip)
  end

  def empty?
    keeps_count == 0 && problems_count == 0 && tries_count == 0
  end
end

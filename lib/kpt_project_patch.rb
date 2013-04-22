require_dependency 'project'

module KPT
  module ProjectPatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
        has_many :kpt_boards, :inverse_of => :project, :dependent => :destroy,
                 :order => "#{KptBoard.table_name}.created_at DESC"
      end
    end

    module ClassMethods
    end

    module InstanceMethods
    end
  end
end

Project.send(:include, KPT::ProjectPatch) unless Project.included_modules.include? KPT::ProjectPatch

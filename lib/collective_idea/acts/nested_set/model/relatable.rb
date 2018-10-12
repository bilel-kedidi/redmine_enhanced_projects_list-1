module CollectiveIdea
  module Acts
    module NestedSet
      module Model
        module Relatable
          def is_descendant_of?(other)
            # within_node?(other, self) && same_scope?(other)
            same_nested_set_scope?(other) && other.lft < lft && other.rgt > rgt
          end

        end
      end
    end
  end
end

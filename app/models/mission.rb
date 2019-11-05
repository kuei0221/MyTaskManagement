class Mission < ApplicationRecord
  default_scope {order(created_at: :asc)}
end

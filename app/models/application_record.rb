class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def on_assert_add_error condition, attribute, error_message
    
    if condition
      errors.add(attribute, error_message)
    end
  end
end

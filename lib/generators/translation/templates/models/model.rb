class <%= model_name %>Translation < ActiveRecord::Base
  belongs_to :<%=model_name.downcase%>
end

class <%= migration_name %> < ActiveRecord::Migration
  def self.up
   <% models.each do |model, array| -%>
    create_table "<%= model.table_name.singularize %>_translations", :force => true do |t|
      <% array.each do |attr| -%>
        t.column :<%= attr -%>, :<%= model.columns_hash[attr.to_s].type -%>

      <% end -%>
      t.integer :<%= model.class_name.underscore -%>_id
      t.string :locale
      t.timestamps
    end
   <% end -%>
  end
  def self.down
   <% models.keys.each do |model| -%>
   drop_table "<%= model.class_name.underscore %>_translations"
   <% end -%>
  end
end

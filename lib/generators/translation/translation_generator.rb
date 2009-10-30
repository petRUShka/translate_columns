class TranslationGenerator < Rails::Generator::Base
  def initialize(args, options = {})
    super
    Dir.glob(RAILS_ROOT + '/app/models/*.rb').each{ |file| require file }
    @models_all = Object.subclasses_of(ActiveRecord::Base)
    @models_all_names = @models_all.map{|m| m.class_name} 
    @models = @models_all.inject(Hash.new) do |result, m|
      mo = m.new
      begin
        array = mo.columns_to_translate
      rescue
        result
      else
        if @models_all_names.include?(m.class_name + "Translation")
          result
        else
          result.merge({m => array})
        end
      end
    end
  end
  
  def manifest
    record do |m|
        m.migration_template 'migrations/create_translation.rb', 'db/migrate',
                             :assigns => { :migration_name => "CreateTranslation", :models => @models },
                             :migration_file_name => "create_translation"
        @models.keys.each do |model|
          m.template('models/model.rb', "app/models/#{model.class_name.underscore}_translation.rb",
                             :assigns => { :model_name => model.class_name })
          m.gsub_file "app/models/#{model.class_name.underscore}.rb", /translate_columns.*$/i do |match|
              "#{match}\n  has_many :translations, :class_name => '#{model.class_name}Translation'\n"
          end
        end
    end
  end
end

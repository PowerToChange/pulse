class AddEnglishValueToAccountadmin < ActiveRecord::Migration

  MODELS = [AccountadminAccesscategory, AccountadminAccessgroup, AccountadminAccountgroup, AccountadminLanguage]

  def self.up

    MODELS.each do |model|
      add_column model.table_name, :english_value, :text
      model.reset_column_information
      model.all.each do |row|
        english = ::SiteMultilingualLabel.all(:select => ::SiteMultilingualLabel.__(:label),
          :conditions => ["#{::SiteMultilingualLabel.__(:key)} = ? and #{::SiteMultilingualLabel.__(:label)} not like ?", row.key, "[%]%"] )
        row.english_value = english.first.label
        row.save
      end
    end

  end

  def self.down
    MODELS.each do |model|
      remove_column model.table_name, :english_value
    end
  end
end

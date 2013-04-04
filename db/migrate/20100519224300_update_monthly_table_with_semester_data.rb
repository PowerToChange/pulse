class UpdateMonthlyTableWithSemesterData < ActiveRecord::Migration
  def self.up
    Rake::Task['pulse:update_monthly_report'].invoke
  end

  def self.down
  end
end

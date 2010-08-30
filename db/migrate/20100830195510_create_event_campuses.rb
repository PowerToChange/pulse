class CreateEventCampuses < ActiveRecord::Migration
  def self.up
    create_table :event_campuses do |t|
      t.integer :event_id
      t.integer :campus_id

      t.timestamps
    end
  end

  def self.down
    drop_table :event_campuses
  end
end

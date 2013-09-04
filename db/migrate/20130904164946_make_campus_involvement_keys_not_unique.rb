class MakeCampusInvolvementKeysNotUnique < ActiveRecord::Migration
  def self.up
    remove_index "campus_involvements", :name => "index_campus_involvements_on_p_id_and_c_id_and_end_date"
    add_index "campus_involvements", ["person_id", "campus_id", "end_date"], :name => "index_campus_involvements_on_p_id_and_c_id_and_end_date", :unique => false
  end

  def self.down
    remove_index "campus_involvements", :name => "index_campus_involvements_on_p_id_and_c_id_and_end_date"
    add_index "campus_involvements", ["person_id", "campus_id", "end_date"], :name => "index_campus_involvements_on_p_id_and_c_id_and_end_date", :unique => true
  end
end

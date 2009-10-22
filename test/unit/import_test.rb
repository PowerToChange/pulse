require File.dirname(__FILE__) + '/../test_helper'

class ImportTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "run import with no good rows" do
    import =  create_import('files/sample_import_bad.csv')
    successful, unsuccessful = import.run!(Campus.first.id, Ministry.first, people(:josh))
    assert_equal(0, successful.length)
    assert_equal(1, unsuccessful.length)
  end
  
  test "create from xls file" do
    import =  create_import('files/sample_import.xls')
    successful, unsuccessful = import.run!(Campus.first.id, Ministry.first, people(:josh))
    assert_equal(1, successful.length)
    assert_equal(0, unsuccessful.length)
  end
   
   test "create with one good row, one bad" do
    import =  create_import('files/sample_import_one_of_each.csv')
    successful, unsuccessful = import.run!(Campus.first.id, Ministry.first, people(:josh))
    assert_equal(1, successful.length)
    assert_equal(1, unsuccessful.length)
   end
  
  private
    def create_import(filename)
      use_temp_file(filename) do |file|
        Import.create!(:uploaded_data => fixture_file_upload(file, 'text/csv'), :parent_id => Campus.first.id, :person_id => 50000)
      end
    end
end

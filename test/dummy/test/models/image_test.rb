require 'test_helper'

class ImageTest < ActiveSupport::TestCase

  setup do
    @valid = File.open("#{Rails.root}/test/fixtures/images/image.png")
    @small = File.open("#{Rails.root}/test/fixtures/images/small.png")
    @large = File.open("#{Rails.root}/test/fixtures/images/large.png")
    @invalid = File.open("#{Rails.root}/test/fixtures/images/invalid.png")
    @undefined = File.open("#{Rails.root}/test/fixtures/images/undefined.zip")
  end

  teardown do
    @valid.close
    @small.close
    @large.close
    @invalid.close
    @undefined.close
  end

  test "valid file assignment" do
    @image = Image.create(file: @valid)
    assert @image.valid?, "valid file assignment failed"
    assert @image.file?, "should have a file"
  end

  test "inavlid file assignment" do
    @image = Image.create(file: @invalid)
    assert !@image.valid?, "invalid file assignment succeeded"
    assert @image.errors[:file].include? "must be an image file"
  end

  test "undefined file assignment" do
    @image = Image.create(file: @undefined)
    assert !@image.valid?, "undefined file assignment succeeded"
    assert @image.errors[:file].include? "extension is invalid"
  end

  test "too large file assignment" do
    @image = Image.create(file: @large)
    assert !@image.valid?, "invalid file assignment succeeded"
    assert @image.errors[:file].include? "size must be between 2 kilobytes and 2 megabytes"
  end

  test "too small file assignment" do
    @image = Image.create(file: @small)
    assert !@image.valid?, "invalid file assignment succeeded"
    assert @image.errors[:file].include? "size must be between 2 kilobytes and 2 megabytes"
  end

  test "no file assignment" do
    @image = Image.create()
    assert !@image.valid?, "invalid file assignment succeeded"
    assert @image.errors[:file].include? "must be attached"
  end

end

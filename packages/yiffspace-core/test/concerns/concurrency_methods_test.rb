# frozen_string_literal: true

require("test_helper")

class ConcurrencyMethodsTest < ActiveSupport::TestCase
  # parallel_find_each runs serially when a transaction is open
  self.use_transactional_tests = false

  class Record < ApplicationRecord
    self.table_name = "tests"
    include(YiffSpace::Concerns::ConcurrencyMethods)
  end

  setup do
    @ids = Array.new(Record.connection_pool.size * 3) { Record.create!.id }
  end

  teardown do
    Record.where(id: @ids).delete_all
  end

  test("parallel_find_each returns connections leased by the block") do
    seen = Concurrent::Array.new
    Record.where(id: @ids).parallel_find_each do |record|
      Record.lease_connection.select_value("SELECT 1")
      sleep(0.05)
      seen << record.id
    end

    assert_equal(@ids.sort, seen.sort)
  end
end

# frozen_string_literal: true

require("test_helper")

module YiffSpace
  module Tables
    class BuilderTest < ActiveSupport::TestCase
      test("row appends a custom table row") do
        table = Builder.new([]) do |t|
          t.row(class: "spacing") do |index|
            "row #{index}"
          end
        end

        row = table.items.first
        assert(row.custom?)
        assert_equal({ class: "spacing" }, row.row_attributes)
        assert_equal("row 0", row.value(0))
      end
    end
  end
end

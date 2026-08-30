# frozen_string_literal: true

class CreateTests < ActiveRecord::Migration[8.1]
  def change
    create_table(:tests, &:timestamps)
  end
end

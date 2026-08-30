# frozen_string_literal: true

module YiffSpace
  module Extensions
    module String
      module Sql
        def to_escaped_for_sql_like
          gsub(/%|_|\*|\\\*|\\\\|\\/) do |str|
            case str
            when "%" then '\%'
            when "_" then '\_'
            when "*" then "%"
            when '\*' then "*"
            when "\\\\", "\\" then "\\\\"
            end
          end
        end
      end
    end
  end
end

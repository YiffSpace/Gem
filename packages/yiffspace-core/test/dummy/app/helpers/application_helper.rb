# frozen_string_literal: true

module ApplicationHelper
  def greeting(name, punctuation = "!", loud: false)
    text = "Hello, #{name}#{punctuation}"
    loud ? text.upcase : text
  end

  def root_link(label = "Home")
    "#{label}: #{root_path(loud: true)}"
  end
end

module BxBlockContentManagement
    class HomePage < ApplicationRecord
      self.table_name = :home_pages
      has_one_attached :image_file, dependent: :destroy
      validates_presence_of :title, :description
      validates_length_of :title, :maximum => 30
      validates_length_of :description, :maximum => 250

    end
  end
  
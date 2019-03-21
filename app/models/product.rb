class Product < ApplicationRecord
  has_many :comments
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :image_url, presence: true
  validates :colour, presence: true
  validates :price, presence: true, :numericality => { :greater_than_or_equal_to => 0 }

  def self.search(search_term)
    if Rails.env.production?
      Product.where("name ilike ?", "%#{search_term}%")
    else
      Product.where("name LIKE ?", "%#{search_term}%")
    end
  end

  def highest_rating_comment
    comments.rating_desc.first
  end

  def lowest_rating_comment
    comments.rating_asc.first
  end
  
  def average_rating
    comments.average(:rating).to_f
  end
end

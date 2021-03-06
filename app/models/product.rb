class Product < ActiveRecord::Base
	validates :title, :description, :price, :image_url, presence: true
validates :price, numericality: {greater_than_or_equal_to: 0.01}
validates :title, uniqueness: true
validates :image_url, allow_blank: true,
format: {with: %r{\.(gif|jpg|png)\Z}i, message: 'must be GIF, JPG, PNG images'}
	has_many :line_items
	has_many :orders, through: :line_items
	before_destroy :ensure_not_referenced_by_any_line_item

def self.search(search)
   where("title LIKE ? OR description LIKE ? OR price LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%") 
end
#...
 private
 # ensure that there are no line items referencing this product
 def ensure_not_referenced_by_any_line_item
 if line_items.empty?
 return true
 else
 errors.add(:base, 'Line Items present')
 return false
 end
 end
end
class Item < ApplicationRecord
# has_many :reviews, through: users
# has_many :likes, through: users
# has_many :comments, thorough: users
has_many :item_images
accepts_nested_attributes_for :item_images
has_many :item_images, dependent: :destroy
has_many :proceeds
belongs_to :category, optional: true
belongs_to :size, optional: true
belongs_to :brand, optional: true
belongs_to :seller, class_name: "User", optional: true
belongs_to :buyer, class_name: "User", optional: true

scope :newest, -> {order(created_at: :desc)}
scope :chanel_desc, -> {includes(:brand).where(brand_id: 8).limit(3).newest}
scope :nike_desc, -> {includes(:brand).where(brand_id: 1).limit(3).newest}
scope :adidas_desc, -> {includes(:brand).where(brand_id: 2).limit(3).newest}

enum status:{公開停止中: 0, 出品中: 1}
validates :status, inclusion: { in: Item.statuses.keys }
validates :name,           presence: true
validates :introduction,   presence: true
validates :condition,      presence: true
validates :shippingfee,    presence: true
validates :shipfrom,      presence: true
validates :shipping_date,  presence: true
validates :price,          presence: true
validates :status,         presence: true

def self.create_charge_by_customer(price, user)

    Payjp::Charge.create(
      customer: user,
      amount:   price,
      currency: 'jpy',
    )
  end

  def toggle_status!
    公開停止中? ? 出品中! : 公開停止中!
  end

end

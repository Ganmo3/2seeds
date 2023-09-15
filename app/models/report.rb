class Report < ApplicationRecord
  belongs_to :reporter, class_name: "User", foreign_key: "reporter_id"
  belongs_to :reported, class_name: "User", foreign_key: "reported_id"
  belongs_to :content, polymorphic: true
  
  # reporter_idがuser_idである通報の件数を返すクラスメソッド
  def self.reported_count(user_id)
    where(reported_id: user_id).count
  end
  
  enum reason: {
    malicious_expression: 0,
    inappropriate_content: 1,
    misinformation: 2,
    commercial_purposes: 3,
    spam: 4,
    other: 5
  }
end

class Report < ApplicationRecord
  belongs_to :reporter, class_name: "User", foreign_key: "reporter_id"
  belongs_to :reported, class_name: "User", foreign_key: "reported_id"
  belongs_to :content, polymorphic: true
  
  enum reason: {
    malicious_expression: 0,
    promoting_terrorism: 1,
    harassment_bullying: 2,
    self_harm: 3,
    explicit_content: 4,
    misinformation: 5
  }
end

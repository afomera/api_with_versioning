class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  class_attribute :id_prefix, default: nil

  def created
    created_at.to_i
  end

  def livemode
    false
  end

  def metadata
    {}
  end

  def id
    return super unless self.class.id_prefix
    "#{self.class.id_prefix}_#{super}"
  end
end

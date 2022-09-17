class Tag < ApplicationRecord
  before_save :downcase_tag_name
  has_many :group_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :groups, through: :group_tags
  validates :name, uniqueness: true, length: { maximum: 30 }

  def self.search_groups_for(content, method)
    if method == 'perfect'
      tags = Tag.where(name: content)
    elsif method == 'forward'
      tags = Tag.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      tags = Tag.where('name LIKE ?', '%' + content)
    else
      tags = Tag.where('name LIKE ?', '%' + content + '%')
    end

    return tags.inject(int = []) {|result, tag| result + tag.groups}
  end

  private
    def downcase_tag_name
      self.name.downcase!
    end
end

class Description < ActiveRecord::Base
  belongs_to :desc_data, :polymorphic => true
  def local_description(local)
    if local == :zh
      self.cn.blank? ? self.en : self.cn
    else
      self.en
    end
  end
  def local_title(local)
    if local == :zh
      self.title_cn.blank? ? self.title : self.title_cn
    else
      self.title
    end
  end
end

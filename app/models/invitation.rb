class Invitation < ActiveRecord::Base
  after_initialize :init

  belongs_to :user
  belongs_to :team

private
  def init
    self.read ||= false
  end
end

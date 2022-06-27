class Prerequisite < ApplicationRecord
    belongs_to :subject, :dependent => :delete
    belongs_to :subject_prerequisite, class_name: "Subject", :dependent => :delete
end

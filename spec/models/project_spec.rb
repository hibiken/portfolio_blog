require 'rails_helper'

describe Project do
  
  it "is valid with title, description, and link" do
    project = Project.new(title: "Facebook", description: "next big thing", link: "www.facebook.com")
    expect(project).to be_valid
  end

  it "is invalid without title" do
    project = Project.new(title: nil)
    project.valid?
    expect(project.errors[:title]).to include("can't be blank")
  end

  it "is invalid without description" do
    project = Project.new(description: nil)
    project.valid?
    expect(project.errors[:description]).to include("can't be blank")
  end

  it "is invalid without link" do
    project = Project.new(link: nil)
    project.valid?
    expect(project.errors[:link]).to include("can't be blank")
  end
end
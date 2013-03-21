require 'spec_helper'

describe "Static pages" do

  describe "Games page" do
    it "should have the content 'FootySubs'" do
      visit '/static_pages/games'
      page.should have_content('FootySubs')
    end
  end
end
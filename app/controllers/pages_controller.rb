class PagesController < ApplicationController
  def show
  end

  def about
    render layout: "landingpage"
  end

end

require 'spec_helper'

describe ProductsCell do

  context "cell instance" do
    subject { cell(:products) }

    it { should respond_to(:top) }
  end

  context "cell rendering" do
    context "rendering top" do
      subject { render_cell(:products, :top) }

      it { should have_selector("h1", :content => "Products#top") }
      it { should have_selector("p", :content => "Find me in app/cells/products/top.html") }
    end
  end

end

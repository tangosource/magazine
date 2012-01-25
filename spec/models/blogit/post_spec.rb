require "spec_helper"

describe Blogit::Article do
  
  context "should not be valid" do
    
    context "if blogger" do
      
      it "is nil" do
        @article = Blogit::Article.new
        @article.should_not be_valid
        @article.should have(1).error_on(:blogger_id)
      end
      
    end
    
    context "if title" do
      before do
        @article = Blogit::Article.new
      end

      after do
        @article.should_not be_valid
        @article.errors[:title].should_not be_blank
      end

      it "is blank" do
        # before and after block cover this
      end

      it "is less than 10 characters" do
        @article.title = "a" * 9
      end

      it "is longer than 66 characters" do
        @article.title = "a" * 67
      end
            
    end
    
    context "if body" do
      before do
        @article = Blogit::Article.new
      end

      after do
        @article.should_not be_valid
        @article.errors[:body].should_not be_blank
      end
      
      it "is blank" do
        # defined above
      end
      
      it "is shorter than 10 characters" do
        @article.body = "a" * 9
      end
      
    end
    
  end
  
  context "with Blogit.configuration.comments == true" do
    it "should have many comments if " do
      Blogit.configure do |config|
        # this should be true by default anyway
        config.include_comments = true
      end
      User.blogs
      @article = Blogit::Article.new
      lambda { @article.comments }.should_not raise_exception(NoMethodError)
    end
    
  end
  
  describe "blogger_display_name" do
    
    before :all do
      User.blogs
    end
    
    let(:user) { User.create! username: "Jeronimo", password: "password" }
    
    it "should return the display name of the blogger if set" do
      @article = user.articles.build
      @article.blogger_display_name.should == "Jeronimo"
      Blogit.configuration.blogger_display_name_method = :password
      @article.blogger_display_name.should == "password"
    end
    
    it "should return an empty string if blogger doesn't exist" do
      Blogit.configuration.blogger_display_name_method = :username
      @article = Blogit::Article.new
      @article.blogger_display_name.should == ""
    end

    it "should raise an exception if blogger display_name method doesn't exist" do
      Blogit.configuration.blogger_display_name_method = :display_name
      @article = user.articles.build
      lambda { @article.blogger_display_name }.should raise_exception(Blogit::ConfigurationError)
    end
    
  end
  
  describe "scopes" do
        
    describe :for_index do
      
      before :all do
        Blogit::Article.destroy_all
        15.times { |i| create :article, created_at: i.days.ago }
      end
      
      it "should order articles by created_at DESC" do
        Blogit::Article.for_index.first.should == Blogit::Article.order("created_at DESC").first
      end
      
      it "should paginate articles in blocks of 5" do
        Blogit::Article.for_index.count.should == 5
      end
      
      it "should accept page no as an argument" do
        Blogit::Article.for_index(2).should == Blogit::Article.order("created_at DESC").offset(5).limit(5)
      end
      
      it "should change the no of articles per page if paginates_per is set" do
        Blogit::Article.paginates_per 3
        Blogit::Article.for_index.count.should eql(3)
      end
      
      
    end
    
    
  end
  

  # TODO: Find a better way to test this
  # describe "with Blogit.configuration.comments == false" do
  # 
  #   it "should not have many comments if Blogit.configuration.comments == false" do
  #     Blogit.configure do |config|
  #       # this should be true by default anyway
  #       config.include_comments = false
  #     end
  #     User.blogs
  #     @article = Blogit::Article.new
  #     lambda { @article.comments }.should raise_exception(NoMethodError)
  #   end
  # 
  # end
  
end
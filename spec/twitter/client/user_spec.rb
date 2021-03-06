require 'helper'

describe Twitter::Client do
  before do
    @client = Twitter::Client.new
  end

  describe ".user" do

    context "with screen name passed" do

        before do
          stub_get("/1/users/show.json").
            with(:query => {:screen_name => "sferik"}).
            to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.user("sferik")
          a_get("/1/users/show.json").
            with(:query => {:screen_name => "sferik"}).
            should have_been_made
        end

        it "should return extended information of a given user" do
          user = @client.user("sferik")
          user.should be_a Twitter::User
          user.name.should == "Erik Michaels-Ober"
        end

    end

    context "with screen name including '@' passed" do

      before do
        stub_get("/1/users/show.json").
          with(:query => {:screen_name => "@sferik"}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.user("@sferik")
        a_get("/1/users/show.json").
          with(:query => {:screen_name => "@sferik"}).
          should have_been_made
      end

    end

    context "with numeric screen name passed" do

      before do
        stub_get("/1/users/show.json").
          with(:query => {:screen_name => "0"}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.user("0")
        a_get("/1/users/show.json").
          with(:query => {:screen_name => "0"}).
          should have_been_made
      end

    end

    context "with user ID passed" do

      before do
        stub_get("/1/users/show.json").
          with(:query => {:user_id => "7505382"}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.user(7505382)
        a_get("/1/users/show.json").
          with(:query => {:user_id => "7505382"}).
          should have_been_made
      end

    end

    context "without screen name or user ID passed" do

      before do
        @client.stub!(:get_screen_name).and_return('sferik')
        stub_get("/1/users/show.json").
          with(:query => {:screen_name => "sferik"}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.user
        a_get("/1/users/show.json").
          with(:query => {:screen_name => "sferik"}).
          should have_been_made
      end

    end

  end

  describe ".user?" do

    before do
      stub_get("/1/users/show.json").
        with(:query => {:screen_name => "sferik"}).
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      stub_get("/1/users/show.json").
        with(:query => {:screen_name => "pengwynn"}).
        to_return(:body => fixture("not_found.json"), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the correct resource" do
      @client.user?("sferik")
      a_get("/1/users/show.json").
        with(:query => {:screen_name => "sferik"}).
        should have_been_made
    end

    it "should return true if user exists" do
      user = @client.user?("sferik")
      user.should be_true
    end

    it "should return false if user does not exist" do
      user = @client.user?("pengwynn")
      user.should be_false
    end

  end

  describe ".users" do

    context "with screen names passed" do

      before do
        stub_get("/1/users/lookup.json").
          with(:query => {:screen_name => "sferik,pengwynn"}).
          to_return(:body => fixture("users.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.users("sferik", "pengwynn")
        a_get("/1/users/lookup.json").
          with(:query => {:screen_name => "sferik,pengwynn"}).
          should have_been_made
      end

      it "should return up to 100 users worth of extended information" do
        users = @client.users("sferik", "pengwynn")
        users.should be_an Array
        users.first.should be_a Twitter::User
        users.first.name.should == "Erik Michaels-Ober"
      end

    end

    context "with numeric screen names passed" do

      before do
        stub_get("/1/users/lookup.json").
          with(:query => {:screen_name => "0,311"}).
          to_return(:body => fixture("users.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.users("0", "311")
        a_get("/1/users/lookup.json").
          with(:query => {:screen_name => "0,311"}).
          should have_been_made
      end

    end

    context "with user IDs passed" do

      before do
        stub_get("/1/users/lookup.json").
          with(:query => {:user_id => "7505382,14100886"}).
          to_return(:body => fixture("users.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.users(7505382, 14100886)
        a_get("/1/users/lookup.json").
          with(:query => {:user_id => "7505382,14100886"}).
          should have_been_made
      end

    end

    context "with both screen names and user IDs passed" do

      before do
        stub_get("/1/users/lookup.json").
          with(:query => {:screen_name => "sferik", :user_id => "14100886"}).
          to_return(:body => fixture("users.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.users("sferik", 14100886)
        a_get("/1/users/lookup.json").
          with(:query => {:screen_name => "sferik", :user_id => "14100886"}).
          should have_been_made
      end

    end

  end

  describe ".user_search" do

    before do
      stub_get("/1/users/search.json").
        with(:query => {:q => "Erik Michaels-Ober"}).
        to_return(:body => fixture("user_search.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the correct resource" do
      @client.user_search("Erik Michaels-Ober")
      a_get("/1/users/search.json").
        with(:query => {:q => "Erik Michaels-Ober"}).
        should have_been_made
    end

    it "should return an array of user search results" do
      user_search = @client.user_search("Erik Michaels-Ober")
      user_search.should be_an Array
      user_search.first.should be_a Twitter::User
      user_search.first.name.should == "Erik Michaels-Ober"
    end

  end

  describe ".suggestions" do

    context "with a category slug passed" do

      before do
        stub_get("/1/users/suggestions/art-design.json").
          to_return(:body => fixture("category.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.suggestions("art-design")
        a_get("/1/users/suggestions/art-design.json").
          should have_been_made
      end

      it "should return the users in a given category of the Twitter suggested user list" do
        category = @client.suggestions("art-design")
        category.should be_a Hash
        category['name'].should == "Art & Design"
      end

    end

    context "without arguments passed" do

      before do
        stub_get("/1/users/suggestions.json").
          to_return(:body => fixture("suggestions.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.suggestions
        a_get("/1/users/suggestions.json").
          should have_been_made
      end

      it "should return the list of suggested user categories" do
        suggestions = @client.suggestions
        suggestions.should be_an Array
        suggestions.first.should be_a Hash
        suggestions.first['name'].should == "Art & Design"
      end

    end

  end

  describe ".suggest_users" do

    before do
      stub_get("/1/users/suggestions/art-design/members.json").
        to_return(:body => fixture("members.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the correct resource" do
      @client.suggest_users("art-design")
      a_get("/1/users/suggestions/art-design/members.json").
        should have_been_made
    end

    it "should return users in a given category of the Twitter suggested user list and return their most recent status if they are not a protected user" do
      suggest_users = @client.suggest_users("art-design")
      suggest_users.should be_a Array
      suggest_users.first.should be_a Twitter::User
      suggest_users.first.name.should == "OMGFacts"
    end

  end

  describe ".profile_image" do

    context "with screen name passed" do

      before do
        stub_get("/1/users/profile_image/sferik").
          to_return(fixture("profile_image.text"))
      end

      it "should redirect to the correct resource" do
        profile_image = @client.profile_image("sferik")
        a_get("/1/users/profile_image/sferik").
          with(:status => 302).
          should have_been_made
        profile_image.should == "http://a0.twimg.com/profile_images/323331048/me_normal.jpg"
      end

    end

    context "without screen name passed" do

      before do
        @client.stub!(:get_screen_name).and_return('sferik')
        stub_get("/1/users/profile_image/sferik").
          to_return(fixture("profile_image.text"))
      end

      it "should redirect to the correct resource" do
        profile_image = @client.profile_image
        a_get("/1/users/profile_image/sferik").
          with(:status => 302).
          should have_been_made
        profile_image.should == "http://a0.twimg.com/profile_images/323331048/me_normal.jpg"
      end

    end

  end

  describe ".recommendations" do

    before do
      stub_get("/1/users/recommendations.json").
        to_return(:body => fixture("recommendations.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the correct resource" do
      @client.recommendations
      a_get("/1/users/recommendations.json").
        should have_been_made
    end

    it "should return recommended users for the authenticated user" do
      recommendations = @client.recommendations
      recommendations.should be_an Array
      recommendations.first.should be_a Twitter::User
      recommendations.first.name.should == "John Trupiano"
    end
  end

  describe ".contributees" do

    context "with a screen name passed" do

      before do
        stub_get("/1/users/contributees.json").
          with(:query => {:screen_name => "sferik"}).
          to_return(:body => fixture("contributees.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.contributees("sferik")
        a_get("/1/users/contributees.json").
          with(:query => {:screen_name => "sferik"}).
          should have_been_made
      end

      it "should return a user's contributees" do
        contributees = @client.contributees("sferik")
        contributees.should be_an Array
        contributees.first.should be_a Twitter::User
        contributees.first.name.should == "Twitter API"
      end
    end

    context "without arguments passed" do

      before do
        @client.stub!(:get_screen_name).and_return('sferik')
        stub_get("/1/users/contributees.json").
          with(:query => {:screen_name => "sferik"}).
          to_return(:body => fixture("contributees.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.contributees
        a_get("/1/users/contributees.json").
          with(:query => {:screen_name => "sferik"}).
          should have_been_made
      end

      it "should return a user's contributees" do
        contributees = @client.contributees
        contributees.should be_an Array
        contributees.first.should be_a Twitter::User
        contributees.first.name.should == "Twitter API"
      end
    end
  end

  describe ".contributors" do

    context "with a screen name passed" do

      before do
        stub_get("/1/users/contributors.json").
          with(:query => {:screen_name => "sferik"}).
          to_return(:body => fixture("contributors.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.contributors("sferik")
        a_get("/1/users/contributors.json").
          with(:query => {:screen_name => "sferik"}).
          should have_been_made
      end

      it "should return a user's contributors" do
        contributors = @client.contributors("sferik")
        contributors.should be_an Array
        contributors.first.should be_a Twitter::User
        contributors.first.name.should == "Biz Stone"
      end
    end

    context "without arguments passed" do

      before do
        @client.stub!(:get_screen_name).and_return('sferik')
        stub_get("/1/users/contributors.json").
          with(:query => {:screen_name => "sferik"}).
          to_return(:body => fixture("contributors.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.contributors
        a_get("/1/users/contributors.json").
          with(:query => {:screen_name => "sferik"}).
          should have_been_made
      end

      it "should return a user's contributors" do
        contributors = @client.contributors
        contributors.should be_an Array
        contributors.first.should be_a Twitter::User
        contributors.first.name.should == "Biz Stone"
      end
    end
  end
end

require 'helper'

describe Twitter::Client do
  before do
    @client = Twitter::Client.new
  end

  describe ".list_subscribers" do

    context "with screen name passed" do

      before do
        stub_get("/1/lists/subscribers.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :cursor => "-1"}).
          to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_subscribers("sferik", "presidents")
        a_get("/1/lists/subscribers.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :cursor => "-1"}).
          should have_been_made
      end

      it "should return the subscribers of the specified list" do
        list_subscribers = @client.list_subscribers("sferik", "presidents")
        list_subscribers.should be_a Twitter::Cursor
        list_subscribers.users.should be_an Array
        list_subscribers.users.first.should be_a Twitter::User
        list_subscribers.users.first.name.should == "Erik Michaels-Ober"
      end

    end

    context "with an Integer user passed" do

      before do
        stub_get("/1/lists/subscribers.json").
          with(:query => {:owner_id => '12345678', :slug => 'presidents', :cursor => "-1"}).
          to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_subscribers(12345678, "presidents")
        a_get("/1/lists/subscribers.json").
          with(:query => {:owner_id => '12345678', :slug => 'presidents', :cursor => "-1"}).
          should have_been_made
      end

    end

    context "with an Integer list_id passed" do

      before do
        stub_get("/1/lists/subscribers.json").
          with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678', :cursor => "-1"}).
          to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_subscribers('sferik', 12345678)
        a_get("/1/lists/subscribers.json").
          with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678', :cursor => "-1"}).
          should have_been_made
      end

    end

    context "without screen name passed" do

      before do
        @client.stub!(:get_screen_name).and_return('sferik')
        stub_get("/1/lists/subscribers.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :cursor => "-1"}).
          to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_subscribers("presidents")
        a_get("/1/lists/subscribers.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :cursor => "-1"}).
          should have_been_made
      end

    end

  end

  describe ".list_subscribe" do

    context "with screen name passed" do

      before do
        stub_post("/1/lists/subscribers/create.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_subscribe("sferik", "presidents")
        a_post("/1/lists/subscribers/create.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          should have_been_made
      end

      it "should return the specified list" do
        list = @client.list_subscribe("sferik", "presidents")
        list.should be_a Twitter::List
        list.name.should == "presidents"
      end

    end

    context "with an Integer user_id passed" do

      before do
        stub_post("/1/lists/subscribers/create.json").
          with(:body => {:owner_id => '12345678', :slug => 'presidents'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_subscribe(12345678, "presidents")
        a_post("/1/lists/subscribers/create.json").
          with(:body => {:owner_id => '12345678', :slug => 'presidents'}).
          should have_been_made
      end

    end

    context "with an Integer list_id passed" do

      before do
        stub_post("/1/lists/subscribers/create.json").
          with(:body => {:owner_screen_name => 'sferik', :list_id => '12345678'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_subscribe('sferik', 12345678)
        a_post("/1/lists/subscribers/create.json").
          with(:body => {:owner_screen_name => 'sferik', :list_id => '12345678'}).
          should have_been_made
      end

    end

    context "without screen name passed" do

      before do
        @client.stub!(:get_screen_name).and_return('sferik')
        stub_post("/1/lists/subscribers/create.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_subscribe("presidents")
        a_post("/1/lists/subscribers/create.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          should have_been_made
      end

    end

  end

  describe ".list_unsubscribe" do

    context "with screen name" do

      before do
        stub_post("/1/lists/subscribers/destroy.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_unsubscribe("sferik", "presidents")
        a_post("/1/lists/subscribers/destroy.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          should have_been_made
      end

      it "should return the specified list" do
        list = @client.list_unsubscribe("sferik", "presidents")
        list.should be_a Twitter::List
        list.name.should == "presidents"
      end

    end

    context "with an Integer user_id passed" do

      before do
        stub_post("/1/lists/subscribers/destroy.json").
          with(:body => {:owner_id => '12345678', :slug => 'presidents'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_unsubscribe(12345678, "presidents")
        a_post("/1/lists/subscribers/destroy.json").
          with(:body => {:owner_id => '12345678', :slug => 'presidents'}).
          should have_been_made
      end

    end

    context "with an Integer list_id passed" do

      before do
        stub_post("/1/lists/subscribers/destroy.json").
          with(:body => {:owner_screen_name => 'sferik', :list_id => '12345678'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_unsubscribe('sferik', 12345678)
        a_post("/1/lists/subscribers/destroy.json").
          with(:body => {:owner_screen_name => 'sferik', :list_id => '12345678'}).
          should have_been_made
      end

    end

    context "without screen name" do

      before do
        @client.stub!(:get_screen_name).and_return('sferik')
        stub_post("/1/lists/subscribers/destroy.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_unsubscribe("presidents")
        a_post("/1/lists/subscribers/destroy.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          should have_been_made
      end

    end

  end

  describe ".list_subscriber?" do

    context "with screen name passed" do

      before do
        stub_get("/1/lists/subscribers/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '813286'}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/lists/subscribers/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '18755393'}).
          to_return(:body => fixture("not_found.json"), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/lists/subscribers/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '12345678'}).
          to_return(:body => fixture("not_found.json"), :status => 403, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_subscriber?("sferik", "presidents", 813286)
        a_get("/1/lists/subscribers/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '813286'}).
          should have_been_made
      end

      it "should return true if the specified user subscribes to the specified list" do
        list_subscriber = @client.list_subscriber?("sferik", "presidents", 813286)
        list_subscriber.should be_true
      end

      it "should return false if the specified user does not subscribe to the specified list" do
        list_subscriber = @client.list_subscriber?("sferik", "presidents", 18755393)
        list_subscriber.should be_false
      end

      it "should return false if user does not exist" do
        list_subscriber = @client.list_subscriber?("sferik", "presidents", 12345678)
        list_subscriber.should be_false
      end

    end

    context "with an Integer owner_id passed" do

      before do
        stub_get("/1/lists/subscribers/show.json").
          with(:query => {:owner_id => '12345678', :slug => 'presidents', :user_id => '813286'}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_subscriber?(12345678, "presidents", 813286)
        a_get("/1/lists/subscribers/show.json").
          with(:query => {:owner_id => '12345678', :slug => 'presidents', :user_id => '813286'}).
          should have_been_made
      end

    end

    context "with an Integer list_id passed" do

      before do
        stub_get("/1/lists/subscribers/show.json").
          with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678', :user_id => '813286'}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_subscriber?('sferik', 12345678, 813286)
        a_get("/1/lists/subscribers/show.json").
          with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678', :user_id => '813286'}).
          should have_been_made
      end

    end

    context "with screen name passed for user_to_check" do

      before do
        stub_get("/1/lists/subscribers/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :screen_name => 'erebor'}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_subscriber?("sferik", "presidents", 'erebor')
        a_get("/1/lists/subscribers/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :screen_name => 'erebor'}).
          should have_been_made
      end

    end

    context "without screen name passed" do

      before do
        @client.stub!(:get_screen_name).and_return('sferik')
        stub_get("/1/lists/subscribers/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '813286'}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_subscriber?("presidents", 813286)
        a_get("/1/lists/subscribers/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '813286'}).
          should have_been_made
      end
    end
  end
end

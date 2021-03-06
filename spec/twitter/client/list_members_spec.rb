require 'helper'

describe Twitter::Client do
  before do
    @client = Twitter::Client.new
  end

  describe ".list_members" do

    context "with screen name" do

      before do
        stub_get("/1/lists/members.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :cursor => "-1"}).
          to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_members("sferik", "presidents")
        a_get("/1/lists/members.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :cursor => "-1"}).
          should have_been_made
      end

      it "should return the members of the specified list" do
        list_members = @client.list_members("sferik", "presidents")
        list_members.should be_a Twitter::Cursor
        list_members.users.should be_an Array
        list_members.users.first.should be_a Twitter::User
        list_members.users.first.name.should == "Erik Michaels-Ober"
      end

    end

    context "with an Integer user_id passed" do

      before do
        stub_get("/1/lists/members.json").
          with(:query => {:owner_id => '12345678', :slug => 'presidents', :cursor => "-1"}).
          to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_members(12345678, 'presidents')
        a_get("/1/lists/members.json").
          with(:query => {:owner_id => '12345678', :slug => 'presidents', :cursor => "-1"}).
          should have_been_made
      end

    end

    context "without screen name" do

      before do
        @client.stub!(:get_screen_name).and_return('sferik')
        stub_get("/1/lists/members.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :cursor => "-1"}).
          to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_members("presidents")
        a_get("/1/lists/members.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :cursor => "-1"}).
          should have_been_made
      end

    end

  end

  describe ".list_add_member" do

    context "with screen name passed" do

      before do
        stub_post("/1/lists/members/create.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_add_member("sferik", "presidents", 813286)
        a_post("/1/lists/members/create.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286"}).
          should have_been_made
      end

      it "should return the list" do
        list = @client.list_add_member("sferik", "presidents", 813286)
        list.should be_a Twitter::List
        list.name.should == "presidents"
      end

    end

    context "with an Integer user_id passed" do

      before do
        stub_post("/1/lists/members/create.json").
          with(:body => {:owner_id => '12345678', :slug => 'presidents', :user_id => "813286"}).
          to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_add_member(12345678, 'presidents', 813286)
        a_post("/1/lists/members/create.json").
          with(:body => {:owner_id => '12345678', :slug => 'presidents', :user_id => "813286"}).
          should have_been_made
      end

    end

    context "with an Integer list_id passed" do

      before do
        stub_post("/1/lists/members/create.json").
          with(:body => {:owner_screen_name => 'sferik', :list_id => '12345678', :user_id => "813286"}).
          to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_add_member('sferik', 12345678, 813286)
        a_post("/1/lists/members/create.json").
          with(:body => {:owner_screen_name => 'sferik', :list_id => '12345678', :user_id => "813286"}).
          should have_been_made
      end

    end

    context "without screen name passed" do

      before do
        @client.stub!(:get_screen_name).and_return('sferik')
        stub_post("/1/lists/members/create.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_add_member("presidents", 813286)
        a_post("/1/lists/members/create.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286"}).
          should have_been_made
      end

    end

  end

  describe ".list_add_members" do

    context "with screen name passed" do

      before do
        stub_post("/1/lists/members/create_all.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286,18755393"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_add_members("sferik", "presidents", [813286, 18755393])
        a_post("/1/lists/members/create_all.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286,18755393"}).
          should have_been_made
      end

      it "should return the list" do
        list = @client.list_add_members("sferik", "presidents", [813286, 18755393])
        list.should be_a Twitter::List
        list.name.should == "presidents"
      end

    end

    context "with an Integer user_id passed" do

      before do
        stub_post("/1/lists/members/create_all.json").
          with(:body => {:owner_id => '12345678', :slug => 'presidents', :user_id => "813286,18755393"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_add_members(12345678, "presidents", [813286, 18755393])
        a_post("/1/lists/members/create_all.json").
          with(:body => {:owner_id => '12345678', :slug => 'presidents', :user_id => "813286,18755393"}).
          should have_been_made
      end

    end

    context "with an Integer list_id passed" do

      before do
        stub_post("/1/lists/members/create_all.json").
          with(:body => {:owner_screen_name => 'sferik', :list_id => '12345678', :user_id => "813286,18755393"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_add_members('sferik', 12345678, [813286, 18755393])
        a_post("/1/lists/members/create_all.json").
          with(:body => {:owner_screen_name => 'sferik', :list_id => '12345678', :user_id => "813286,18755393"}).
          should have_been_made
      end

    end

    context "with a combination of member IDs and member screen names to add" do

      before do
        stub_post("/1/lists/members/create_all.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286,18755393", :screen_name => "pengwynn,erebor"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_add_members('sferik', 'presidents', [813286, 'pengwynn', 18755393, 'erebor'])
        a_post("/1/lists/members/create_all.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286,18755393", :screen_name => "pengwynn,erebor"}).
          should have_been_made
      end

    end

    context "without screen name passed" do

      before do
        @client.stub!(:get_screen_name).and_return('sferik')
        stub_post("/1/lists/members/create_all.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286,18755393"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_add_members("presidents", [813286, 18755393])
        a_post("/1/lists/members/create_all.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286,18755393"}).
          should have_been_made
      end

    end

  end

  describe ".list_remove_member" do

    context "with screen name passed" do

      before do
        stub_post("/1/lists/members/destroy.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_remove_member("sferik", "presidents", 813286)
        a_post("/1/lists/members/destroy.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286"}).
          should have_been_made
      end

      it "should return the list" do
        list = @client.list_remove_member("sferik", "presidents", 813286)
        list.should be_a Twitter::List
        list.name.should == "presidents"
      end

    end

    context "with an Integer user_id passed" do

      before do
        stub_post("/1/lists/members/destroy.json").
          with(:body => {:owner_id => '12345678', :slug => 'presidents', :user_id => "813286"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_remove_member(12345678, "presidents", 813286)
        a_post("/1/lists/members/destroy.json").
          with(:body => {:owner_id => '12345678', :slug => 'presidents', :user_id => "813286"}).
          should have_been_made
      end

    end

    context "with an Integer list_id passed" do

      before do
        stub_post("/1/lists/members/destroy.json").
          with(:body => {:owner_screen_name => 'sferik', :list_id => '12345678', :user_id => "813286"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_remove_member('sferik', 12345678, 813286)
        a_post("/1/lists/members/destroy.json").
          with(:body => {:owner_screen_name => 'sferik', :list_id => '12345678', :user_id => "813286"}).
          should have_been_made
      end

    end

    context "with a screen name to remove" do

      before do
        stub_post("/1/lists/members/destroy.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :screen_name => "erebor"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_remove_member('sferik', 'presidents', 'erebor')
        a_post("/1/lists/members/destroy.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :screen_name => "erebor"}).
          should have_been_made
      end

    end

    context "without screen name passed" do

      before do
        @client.stub!(:get_screen_name).and_return('sferik')
        stub_post("/1/lists/members/destroy.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_remove_member("presidents", 813286)
        a_post("/1/lists/members/destroy.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286"}).
          should have_been_made
      end

    end

  end

  describe ".list_member?" do

    context "with screen name passed" do

      before do
        stub_get("/1/lists/members/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '813286'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/lists/members/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '65493023'}).
          to_return(:body => fixture("not_found.json"), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/lists/members/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '12345678'}).
          to_return(:body => fixture("not_found.json"), :status => 403, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_member?("sferik", "presidents", 813286)
        a_get("/1/lists/members/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '813286'}).
          should have_been_made
      end

      it "should return true if user is a list member" do
        list_member = @client.list_member?("sferik", "presidents", 813286)
        list_member.should be_true
      end

      it "should return false if user is not a list member" do
        list_member = @client.list_member?("sferik", "presidents", 65493023)
        list_member.should be_false
      end

      it "should return false if user does not exist" do
        list_member = @client.list_member?("sferik", "presidents", 12345678)
        list_member.should be_false
      end

    end

    context "with an Integer owner_id passed" do

      before do
        stub_get("/1/lists/members/show.json").
          with(:query => {:owner_id => '12345678', :slug => 'presidents', :user_id => '813286'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_member?(12345678, "presidents", 813286)
        a_get("/1/lists/members/show.json").
          with(:query => {:owner_id => '12345678', :slug => 'presidents', :user_id => '813286'}).
          should have_been_made
      end

    end

    context "with an Integer list_id passed" do

      before do
        stub_get("/1/lists/members/show.json").
          with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678', :user_id => '813286'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_member?('sferik', 12345678, 813286)
        a_get("/1/lists/members/show.json").
          with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678', :user_id => '813286'}).
          should have_been_made
      end

    end

    context "with screen name passed for user_to_check" do

      before do
        stub_get("/1/lists/members/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :screen_name => 'erebor'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/.json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_member?("sferik", "presidents", 'erebor')
        a_get("/1/lists/members/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :screen_name => 'erebor'}).
          should have_been_made
      end

    end

    context "without screen name passed" do

      before do
        @client.stub!(:get_screen_name).and_return('sferik')
        stub_get("/1/lists/members/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '813286'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/.json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_member?("presidents", 813286)
        a_get("/1/lists/members/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '813286'}).
          should have_been_made
      end
    end
  end
end

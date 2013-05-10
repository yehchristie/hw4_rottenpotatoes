#Chrstie HW4
require 'spec_helper'

describe MoviesController do
    describe "add director" do 
        before :each do
            @m=mock(Movie, title: "Star Wars", director: "director", id: "1")
            Movie.stub!(:find).with("1").and_return(@m)
        end    
        it "should call update_attributes and redirect" do
            @m.stub!(:update_attributes!).and_return(true)
            put :update, {:id => "1", :movie => @m}
            response.should redirect_to(movie_path(@m))
        end
    end

    describe "happy path" do
        before :each do
            @m = mock(Movie, title:"Star Wars", director: "director", id: "1")
            Movie.stub!(:find).with("1").and_return(@m)
        end
        it "should generate routing for similar movies" do
            { :post => movie_similar_path(1) }.
            should route_to(:controller => "movies", :action => "similar", :movie_id => "1")
        end

        it "should call the model method that finds similar movies" do
            fake_results = [ mock('Movie'), mock('Movie')]
            Movie.should_receive(:similar_directors).and_return(fake_results)
            get :similar, movie_id: "1"
        end    

        it "should select Similar template and make results available to the template" do
            fake_results = [ mock('Movie'), mock('Movie')]
            Movie.stub(:similar_directors).and_return(fake_results)
            get :similar, movie_id: "1"
            response.should render_template("similar")
            assigns(:movies).should == fake_results
        end    
    end   

    describe "sad path" do
        before :each do
            @m = mock(Movie, title:"Star Wars", director: nil, id: "1")
            Movie.stub!(:find).with("1").and_return(@m)
        end    
        
        it 'should generate routing for Similar Movies' do
            { :post => movie_similar_path(1) }.
            should route_to(:controller => "movies", :action => "similar", :movie_id => "1")
        end

        it "should redirect to the Index page" do
            get :similar, movie_id: "1"
            response.should redirect_to(movies_path)
        end    
    end 

    describe "create and destroy" do
        it "should create a Movie" do
            MoviesController.stub(:create).and_return(mock(Movie))
            post :create, {:id => "1"}
        end    

        it "should destroy a Movie" do
            m = mock(Movie, title: "The Tsar", id: "10", director: nil)
            Movie.should_receive(:find).with("10").and_return(m)
            m.should_receive(:destroy)
            delete :destroy, {:id => "10"}
        end    
    end   
end    

class InfluencersController < ApplicationController

	def new
		@influencer = Influencer.new
	end

	def create
		@influencer = Influencer.new(influencer_params)
		scrapedata(influencer_params)
		redirect_to @influencer
	end

	def index
		@influencer = Influencer.all
	end

	def show
		@influencer = Influencer.find(params[:id])
	end

	def scrapedata(influencer_params)
		@page = Mechanize.new.get("https://www.instagram.com/" + influencer_params[:user])
  		pageContent
	end 

	def pageContent
		info = @page.body.split("<script type=\"text/javascript\">window._sharedData = ")[1]
		json = info.split(";</script>\n<script type=\"text/javascript\">window.__initialDataLoaded(window._sharedData);")[0]

		begin
  			parsed_data = JSON.parse(json)
		rescue JSON::ParserError => ex
			puts "A parsing error has occured with message #{ex.message} and status #{ex.status}"
		end

		addUser(parsed_data)
		getPosts(parsed_data)
	end

	def addUser(parsed_data)
		user = parsed_data["entry_data"]["ProfilePage"][0]["graphql"]["user"]["username"]
		biography = parsed_data["entry_data"]["ProfilePage"][0]["graphql"]["user"]["biography"]
		followers = parsed_data["entry_data"]["ProfilePage"][0]["graphql"]["user"]["edge_followed_by"]["count"]
		following = parsed_data["entry_data"]["ProfilePage"][0]["graphql"]["user"]["edge_follow"]['count']
		businessAccount = parsed_data["entry_data"]["ProfilePage"][0]["graphql"]["user"]["is_business_account"]
		businessCategory = parsed_data["entry_data"]["ProfilePage"][0]["graphql"]["user"]["business_category_name"]
		numberOfPosts = parsed_data["entry_data"]["ProfilePage"][0]["graphql"]["user"]["edge_owner_to_timeline_media"]["count"]
		page_info = parsed_data["entry_data"]["ProfilePage"][0]["graphql"]["user"]["edge_owner_to_timeline_media"]["page_info"]

		@newUser = Influencer.new(user: user, biography: biography, followers: followers, following: following, businessAcounnt: businessAccount, businessCategory: businessCategory, numberOfPosts: numberOfPosts, page_info: page_info)
		@newUser.save
	end

	def getPosts(parsed_data)
		user = parsed_data["entry_data"]["ProfilePage"][0]["graphql"]["user"]["username"]
		posts = parsed_data["entry_data"]["ProfilePage"][0]["graphql"]["user"]["edge_owner_to_timeline_media"]["edges"]

		posts.each do |post|
			caption = post["node"]["edge_media_to_caption"]["edges"][0]["node"]["text"]
			noOfComments = post["node"]["edge_media_to_comment"]["count"]
			postedTime = Time.at(post["node"]["taken_at_timestamp"]).to_datetime
			likes = post["node"]["edge_liked_by"]["count"]
			location = post["node"]["location"]
			ownerOfPost = post["node"]["owner"]
			isVideo = post["node"]["is_video"]
			videoViews = post["node"]["video_view_count"]

			posts = @newUser.posts.build(user: user, caption: caption, noOfComments: noOfComments, postedTime: postedTime, likes: likes, location: location, ownerOfPost: ownerOfPost, isVideo: isVideo, videoViews: videoViews)
			posts.save
		end 
	end

	def influencer_params
		params.require(:influencer).permit(:user)
	end

end

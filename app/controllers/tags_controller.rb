class TagsController < ApplicationController

	def new
		@tags = Tag.new
	end

	def create
		if Tag.exists?(tag_name: tags_params[:user])
			@tags = Tag.find_by(tag_name: tags_params[:user])
			redirect_to @tags
		else
			@tags = Tag.new(tags_params)
			scrapedata(tags_params)
			render "index"
			# redirect_to @tags
		end
	end

	def show
		@tags = Tag.find(tags_params[:id])
		# @tags = Tag.find_by(tag_name: tags_params[:user])
	end

	def index
		@tags = Tag.all.order("created_at DESC")
	end

	# private
	def tags_params
		params.require(:tag).permit(:user)
	end


	def scrapedata(user)
  		@page = Mechanize.new.get("https://www.instagram.com/tags/" + tags_params[:user])
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

		tags = parsed_data["entry_data"]["TagPage"][0]["graphql"]["hashtag"]
		tags_info = tags["edge_hashtag_to_media"]["edges"]

		tag_name = tags["name"]
		popularity_of_tag = tags["edge_hashtag_to_media"]["count"]
		page_info = tags["edge_hashtag_to_media"]["page_info"]

		@tag = Tag.new(tag_name: tag_name, popularity_of_tag: popularity_of_tag, page_info: page_info)
		@tag.save

		tags_info.each_with_index do |tags, i|
			if tags_info[i]["node"]["edge_media_to_caption"]["edges"][0]["node"].empty? 
				comment= "there is no comment here"
			else
				comment = tags_info[i]["node"]["edge_media_to_caption"]["edges"][0]["node"]["text"]
			end
			comment_count = tags_info[i]["node"]["edge_media_to_comment"]["count"].to_s
			like_count = tags_info[i]["node"]["edge_liked_by"]["count"].to_s
			owner_id = tags_info[i]["node"]["owner"]["id"].to_s
			date_added = DateTime.strptime(tags_info[i]["node"]["taken_at_timestamp"].to_s,'%s').to_s
			accessibility_caption = tags_info[i]["node"]["accessibility_caption"].to_s
			userHandler = getOwner(owner_id)

			tags = Tag.new(user: userHandler, comment: comment, comment_count: comment_count, like_count: like_count, owner_id: owner_id, date_added: date_added, accessibility_caption: accessibility_caption)
			tags.save
		end
	end

	def getOwner(userId)
		url = HTTParty.get("https://instadigg.com/id/u/" + userId)
		instadigg ||= Nokogiri::HTML(url)

		if instadigg.css("div.detail p.website a[href]")[0].text.include? 'instagram.com/'
			user_name = instadigg.css("div.detail p.website a[href]")[0].text.split('instagram.com/')[1]
		elsif
			user_name = instadigg.css("div.detail p.website a[href]")[1].text.split('instagram.com/')[1]
		else
			user_name = userId
		end
	end

end

require "sinatra"
require "sinatra/namespace"
require_relative "authentication.rb"
require_relative "api_authentication.rb"
require "stripe"

def api_admin_only!
	api_authenticate!
	if !current_user.admin?
		halt 401, {"message"=>"Error: Not Authorized"}.to_json
	end
end

def placeholder
	halt 501, {message: "Not Implemented"}.to_json
end

namespace '/api' do

	# Make sure they are signed in
	# Gives back current user's account information as JSON
	# EXCLUDE their password from the JSON
	get "/my_account" do
		api_authenticate!
		halt 200, current_user.to_json(exclude: [:password  ])
	end

	# Make sure they are signed in
	# Gives back JSON array representing every
	# video in database
	# EXCLUDE: video_url
	# INCLUDE: result of thumbnail method
	get "/videos" do
		api_authenticate!
		video_array = Video.all
		halt 200, Video.all.to_json(exclude: [:video_url], methods: [:thumbnail])
	end

	# Make sure they are signed in
	# Give back JSON object representing the video with
	# the provided ID
	# INCLUDE: thumbnail, embed_code
	# Authorization: only pro users or admins
	# 404 if not found
	get "/videos/:id" do
		api_authenticate!
		v = Video.get(params["id"])


		if (v != nil) #if video id is not nil
			if current_user.role_id != 0 # if the current role id is pro user or admin halt 200 
				halt 200, v.to_json(methods: [:thumbnail, :embed_code])

			elsif v.pro && current_user.role_id == 0 #if current user is a free user halt 401
				halt 401, v.to_json

			elsif !v.pro && current_user.role_id == 0 #if the video is free and the current user has a free account give the video
				halt 200, v.to_json(methods: [:thumbnail, :embed_code])

			end
	
		else  #if not found halt 404
			halt 404, v.to_json
		end

	end

	# Creates a video from the parameters provided
	# Gives back 201 - Created and JSON representation of the created video
	# Required parameters: title, video_url, description
	# Optional parameters: pro
	# If missing required parameters, give back status 422 - Unprocessable
	# Authorization: only admins
	post "/videos" do
		api_admin_only!
		if(params["title"] != nil && params["video_url"] != nil && params["description"] != nil) #if title, video_url, and description are all NOT nil create a video

			v = Video.new

			v.title = params["title"]

			v.video_url = params["video_url"]

			v.description = params["description"]

			v.save

			halt 201, v.to_json #gives created video
		else

			halt 422, {message: "Missing required parameters"}.to_json
		end

	end

	# Updates the video with the provided ID
	# Optional parameters: title, description, video_url, pro
	# Gives back 200 - OK  and JSON representing updated video
	# 404 if not found
	# Authorization: only admins
	patch "/videos/:id" do
		api_admin_only!
		v = Video.get(params["id"])

		if v != nil #if video id is not nil 
			 
			#updatinh all the parameters such as title, video_url, description
			if params["title"]
				v.title = params["title"]
			end
			if params["video_url"]
				v.video_url = params["video_url"]
			end
			if params["description"]
				v.description = params["description"]
			end

			v.save
			halt 200, v.to_json

		else
			halt 404, {message: "Video not found"}.to_json
		end

	end

	# Deletes the video with the provided ID
	# 404 if not found
	# Authorization: only admins
	delete "/videos/:id" do
		api_admin_only!
		v = Video.get(params["id"])

		if v != nil
			v.destroy  # this will delete the video
			halt 200, {message: "Video is deleted"}.to_json

		else
			halt 400, {message: "Video not found"}.to_json
		end

	

	end
end

# DO NOT TOUCH BELOW THIS LINE
# WEB UI CODE

set :publishable_key, ENV["STRIPE_PUBLISHABLE_KEY"]
set :secret_key, ENV["STRIPE_SECRET_KEY"]

Stripe.api_key = settings.secret_key

def admin_only!
	authenticate!
	redirect "/" unless current_user.admin?
end

get "/" do
	erb :index
end

get "/videos" do
	@videos = Video.all

	erb :videos
end

get "/videos/new" do
	admin_only!
	erb :new_video
end

get "/videos/:id" do
	authenticate!
	@video = Video.get(params["id"])
	if @video.nil?
		redirect "/videos"
	elsif @video.pro && !current_user.pro_user? && !current_user.admin?
		redirect "/upgrade"
	else
		erb :show_video
	end
end

post "/videos/create" do
	admin_only!
	if params["title"] && params["video_url"]
		v = Video.new
		v.title = params["title"]
		v.description = params["description"]
		v.video_url = params["video_url"]
		v.pro = true if params["pro"] == "on"
		v.save
	end
end


get "/upgrade" do
	authenticate!
	redirect "/" if current_user.pro_user? || current_user.admin?

	erb :upgrade
end

post "/charge" do
    authenticate!
	redirect "/" if current_user.pro_user? || current_user.admin?

	begin 
    @amount = 500
    customer = Stripe::Customer.create(
        :email => 'customer@example.com',
        :source  => params[:stripeToken]
    )
    
    charge = Stripe::Charge.create(
        :amount      => @amount,
        :description => 'Sinatra Charge',
        :currency    => 'usd',
        :customer    => customer.id
    )
    current_user.role_id = 1
    current_user.save
	erb :payment_successful

	rescue Stripe::CardError 
		erb :payment_failed
	end

end
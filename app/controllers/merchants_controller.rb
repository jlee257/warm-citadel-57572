class MerchantsController < ApplicationController

	require 'net/http'

	# GET /merchants
	def index
		@merchants = Merchant.find_by merchant_id: 'merchants'

		if @merchant.nil? 
			puts "!!!!!!!!!!!!!!!!!! merchant is nil"

			response = fetch_server

			if !response.is_a? Net::HTTPSuccess
				puts "response body empty"
				render json: { :errors => response.message }, status: response.code
				return
			end

			m = Merchant.new
			m.merchant_id = params[:id]
			m.merchant_info = response.body

			if m.save
				render json: m.merchant_info, status: :ok
			else
				render json: { :errors => m.errors.full_messages }, status: 422
			end

		elsif @merchant.updated_at < 10.minute.ago
			puts "!!!!!!!!!!!!!!!!!! merchant is outdated"

			response = fetch_server

			if !response.is_a? Net::HTTPSuccess
				puts "response body empty"
				render json: { :errors => response.message }, status: response.code
				return
			end

			@merchant.merchant_info = response.body

			if @merchant.save
				render json: @merchant.merchant_info, status: :ok
			else
				render json: { :errors => @merchant.errors.full_messages }, status: 422
			end
		else
			puts "!!!!!!!!!!!!!!!!!! merchant is up to date"

			render json: @merchants.merchant_info, status: :ok
		end

	end


	# GET /merchants/:id
	def show
		@merchant = Merchant.find_by merchant_id: params[:id]

		if @merchant.nil? 
			puts "!!!!!!!!!!!!!!!!!! merchant is nil"

			response = fetch_server params[:id]

			if !response.is_a? Net::HTTPSuccess
				puts "response body empty"
				render json: { :errors => response.message }, status: response.code
				return
			end

			m = Merchant.new
			m.merchant_id = params[:id]
			m.merchant_info = response.body

			if m.save
				render json: m.merchant_info, status: :ok
			else
				render json: { :errors => m.errors.full_messages }, status: 422
			end

		elsif @merchant.updated_at < 10.minute.ago
			puts "!!!!!!!!!!!!!!!!!! merchant is outdated"

			response = fetch_server params[:id]

			if !response.is_a? Net::HTTPSuccess
				puts "response body empty"
				render json: { :errors => response.message }, status: response.code
				return
			end

			@merchant.merchant_info = response.body

			if @merchant.save
				render json: @merchant.merchant_info, status: :ok
			else
				render json: { :errors => @merchant.errors.full_messages }, status: 422
			end

		else
			puts "!!!!!!!!!!!!!!!!!! merchant is up to date"

			render json: @merchant.merchant_info, status: :ok
		end
	end


	def fetch_server(merchant_id=nil)

		if merchant_id.nil?
			puts "param is nil"
			url = 'http://jsonplaceholder.typicode.com/posts'
		else
			puts "param is " + merchant_id
			url = 'http://jsonplaceholder.typicode.com/posts/' + merchant_id
		end

		mykey = 'demo'
		uri = URI(url)

		request = Net::HTTP::Get.new(uri.path)
		# request['Content-Type'] = 'application/xml'
		# request['Accept'] = 'application/xml'
		# request['X-OFFERSDB-API-KEY'] = mykey

		# response = Net::HTTP.new(uri.host,uri.port) do |http|
		#   http.request(request)
		# end

		http = Net::HTTP.new(uri.host, uri.port)
		response = http.request(request)
	end
end
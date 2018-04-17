class MerchantsController < ApplicationController

	require 'net/http'

	# GET /merchants
	def index
		@merchants = Merchant.find_by merchant_id: 'merchants'

		if @merchants.nil? 

			url = 'https://jsonplaceholder.typicode.com/posts'
			mykey = 'demo'
			uri = URI(url)

			request = Net::HTTP::Get.new(uri.path)
			# request['Content-Type'] = 'application/xml'
			# request['Accept'] = 'application/xml'
			# request['X-OFFERSDB-API-KEY'] = mykey

			response = Net::HTTP.new(uri.host,uri.port) do |http|
			  http.request(request)
			end

			m = Merchant.new
			m.merchant_id = "merchants"
			m.merchant_info = response

			if m.save
				render json: m, status: :ok
			else
				render json: { :errors => m.errors.full_messages }, status: 422
			end
		else
			render json: @merchants.merchant_info, status: :ok
		end


	end


	# GET /merchants/:id
	def show
		@merchant = Merchant.find_by merchant_id: params[:id]

		if @merchant.nil? 

			url = 'http://jsonplaceholder.typicode.com/posts/' + params[:id]
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

			puts response.body

			m = Merchant.new
			m.merchant_id = params[:id]
			m.merchant_info = response.body

			if m.save
				render json: m.merchant_info, status: :ok
			else
				render json: { :errors => m.errors.full_messages }, status: 422
			end
		else
			render json: @merchant.merchant_info, status: :ok
		end
	end

end
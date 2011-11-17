require 'open-uri'

class EarningsController < ApplicationController
  # GET /earnings
  # GET /earnings.xml
  def index
    @earnings = Earning.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @earnings }
    end
  end

  # GET /earnings/1
  # GET /earnings/1.xml
  def show
    @earning = Earning.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @earning }
    end
  end

  # GET /earnings/new
  # GET /earnings/new.xml
  def new
    @earning = Earning.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @earning }
    end
  end

  # GET /earnings/1/edit
  def edit
    @earning = Earning.find(params[:id])
  end

  # POST /earnings
  # POST /earnings.xml
  def create
    @earning = Earning.new(params[:earning])

    respond_to do |format|
      if @earning.save
        format.html { redirect_to(@earning, :notice => 'Earning was successfully created.') }
        format.xml  { render :xml => @earning, :status => :created, :location => @earning }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @earning.errors, :status => :unprocessable_entity }
      end
    end
  end

  # POST /import
  def import
    # load page...
    page = Nokogiri::HTML(open('http://biz.yahoo.com/research/earncal/20111117.html'))
    # find all tables...
    tables = page.xpath("//table")
    # the 6th table is the one we want...
    table_node = tables[6]
    # all the rows we want...
    table_node.children[2..table_node.children.length-2].each do |row|

    end

  end

  # PUT /earnings/1
  # PUT /earnings/1.xml
  def update
    @earning = Earning.find(params[:id])

    respond_to do |format|
      if @earning.update_attributes(params[:earning])
        format.html { redirect_to(@earning, :notice => 'Earning was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @earning.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /earnings/1
  # DELETE /earnings/1.xml
  def destroy
    @earning = Earning.find(params[:id])
    @earning.destroy

    respond_to do |format|
      format.html { redirect_to(earnings_url) }
      format.xml  { head :ok }
    end
  end
end

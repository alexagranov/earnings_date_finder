require 'open-uri'

class EarningsController < ApplicationController
  # GET /earnings
  # GET /earnings.xml
  def index
    @earnings = Earning.find(:all, :order => "released_at DESC, name ASC")

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
    from_args = params[:from_date].split('-')
    from_date = Time.local(from_args[0], from_args[1], from_args[2])

    to_args = params[:to_date].split('-')
    to_date = Time.local(to_args[0], to_args[1], to_args[2])

    while from_date <= to_date
      if from_date.weekday?
        begin
          # load page...
          page = Nokogiri::HTML(open("http://biz.yahoo.com/research/earncal/#{from_date.strftime('%Y%m%d')}.html"))
          # find all tables...
          tables = page.xpath("//table")
          # the 6th table is the one we want...
          table_node = tables[6]
          # all the rows we want...
          table_node.children[2..table_node.children.length-2].each do |stock|
            values = stock.children
            earning = Earning.new(:name => values[0].text,
                                  :cusip => values[1].text,
                                  :released_at => from_date,
                                  :at_time => values[3].text
                                  )
            earning.save!
          end
        rescue Exception => e
        end
      end
      # sleep for a bit to not overwhelm their servers...
      sleep 3 unless from_date == to_date

      # iterate and break the loop once we're past to_date...
      from_date = from_date + 1.day
    end

    redirect_to :action => "index"
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

class Time
  def weekday?
    self.wday != 0 and self.wday != 6
  end
end

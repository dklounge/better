class CommentsController < ApplicationController
  unloadable
  before_filter :find_issue, :only => [:index, :create ]
  before_filter :find_project, :authorize
    
  def index
    @journals = @issue.journals.find(:all, 
                                          :include => [:user, :details], 
                                          :order => "#{Journal.table_name}.created_on DESC",
                                          :conditions => "notes!=''")
    # render :partial => "comment", :collection => @journals, :as => :journal
  end
  
  def create
    journal = @issue.init_journal(User.current, params[:comment])
    journal.save!
    journal.reload
    @issue.reload
    render :json => @issue.to_json(:include => {:journals => {:include => :user}, :status => {:only => :name}, :author => {:only => [:firstname, :lastname]}})
  end
  
  private
    
  def find_issue
    @issue = Issue.find(params[:issue_id])
  end  
  
  def find_project
    @project = @issue.project
  end
end
class Staff::PagesController < Staff::ApplicationController
  before_action :enable_website_subnav
  before_action :set_page, except: :index
  before_action :authorize_page, except: :index

  def index
    @pages = current_website.pages
    authorize(@pages)
  end

  def new; end

  def create
    if @page.update(page_params)
      flash[:success] = "#{@page.name} Page was successfully created."
      redirect_to event_staff_pages_path(current_event, @page)
    else
      render :new
    end
  end

  def edit; end

  def update
    if @page.update(page_params)
      flash[:success] = "#{@page.name} Page was successfully updated."
      redirect_to event_staff_pages_path(current_event, @page)
    else
      render :edit
    end
  end

  private

  def set_page
    @page = if params[:id]
              current_website.pages.find_by(slug: params[:id])
            else
              current_website.pages.build
            end
  end

  def authorize_page
    authorize(@page)
  end

  def page_params
    params.require(:page).permit(:name, :slug, :unpublished_body)
  end
end

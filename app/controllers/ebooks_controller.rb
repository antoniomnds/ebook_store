class EbooksController < ApplicationController
  before_action :set_ebook, only: %i[ show edit update destroy purchase increment_views]
  skip_before_action :require_login, only: %i[ index show increment_views ]

  # GET /ebooks
  def index
    @ebooks = Ebook.filter(params.slice(:tags, :users)).includes(:tags).live
  end

  # GET /ebooks/1
  def show
    @review = Ebook::ReviewFetcher.call(@ebook)
  end

  # GET /ebooks/new
  def new
    @ebook = Ebook.new
  end

  # GET /ebooks/1/edit
  def edit
    unless @ebook.user == current_user
      redirect_to ebooks_url,
                  alert: "You can only edit your ebooks.",
                  status: :see_other
    end
  end

  # POST /ebooks
  def create
    @ebook = Ebook.new(ebook_params)

    if @ebook.save
      redirect_to @ebook, notice: "Ebook was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ebooks/1
  def update
    unless @ebook.user == current_user
      return redirect_to ebooks_url,
                  alert: "You can only edit your ebooks.",
                  status: :see_other
    end
    if @ebook.update(ebook_params)
      redirect_to @ebook, notice: "Ebook was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /ebooks/1
  def destroy
    unless @ebook.user == current_user
      return redirect_to ebooks_url,
                  alert: "You can only delete your ebooks.",
                  status: :see_other
    end

    begin
      @ebook.destroy!
      @ebook.preview_file.purge_later
      @ebook.cover_image.purge_later

      redirect_to ebooks_url, notice: "Ebook was successfully destroyed.", status: :see_other
    rescue ActiveRecord::InvalidForeignKey
      redirect_to request.referer,
                  alert: "Ebook already bought and cannot not be destroyed.",
                  status: :see_other
    rescue ActiveRecord::RecordNotDestroyed => e
      redirect_to request.referer,
                  alert: "Ebook could not be destroyed. #{ e.message }",
                  status: :see_other
    end
  end

  def purchase
    begin
      user = current_user
      Ebook::PurchaseCreator.call(user, @ebook)

      redirect_to @ebook, notice: "Ebook was successfully purchased."
    rescue ActiveRecord::RecordNotFound
      redirect_to ebooks_url, alert: "Ebook could not be found."
    rescue StandardError => e
      redirect_to ebooks_url, alert: "Ebook could not be purchased. #{ e.message }"
    end
  end

  def increment_views
    @ebook.increment!(:views)
    render json: { views: @ebook.views }, status: :ok
  end

  def my_ebooks
    @ebooks = Ebook.filter(params
                             .slice(:tags)
                             .merge(users: [ current_user.id ]))
                   .includes(:tags)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ebook
      @ebook = Ebook.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ebook_params
      params.require(:ebook).permit(:title, :status, :price, :authors, :genre, :publisher,
                                    :publication_date, :pages, :isbn, :sales, :views,
                                    :preview_downloads, :preview_file, :cover_image,
                                    :user_id, tag_ids: [])
    end
end

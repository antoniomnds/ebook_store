class EbooksController < ApplicationController
  before_action :set_ebook, only: %i[ show edit update destroy ]

  # GET /ebooks
  def index
    @ebooks = Ebook.all
  end

  # GET /ebooks/1
  def show
  end

  # GET /ebooks/new
  def new
    @ebook = Ebook.new
  end

  # GET /ebooks/1/edit
  def edit
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
    if @ebook.update(ebook_params)
      redirect_to @ebook, notice: "Ebook was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /ebooks/1
  def destroy
    begin
      @ebook.destroy!
      @ebook.preview_file.purge_later

      redirect_to ebooks_url, notice: "Ebook was successfully destroyed.", status: :see_other
    rescue RecordNotDestroyed => e
      redirect_to ebooks_url,
                  notice: "Ebook could not be destroyed: #{ e.message }",
                  status: :unprocessable_entity
    end
  end

  def purchase
    begin
      ebook = Ebook.find(params[:id])
      user = User.first
      Ebook::PurchaseService.purchase(user, ebook)

      redirect_to ebooks_url, notice: "Ebook was successfully purchased."
    rescue RecordNotFound
      redirect_to ebooks_url, alert: "Ebook could not be found."
    rescue StandardError => e
      redirect_to ebooks_url, alert: "Ebook could not be purchased. #{ e.message }"
    end
  end

  def increment_views
    begin
      ebook = Ebook.find(params[:id])
      ebook.increment!(:views)
      render json: { views: ebook.views }, status: :ok
    rescue RecordNotFound
      render json: { error: "Ebook could not be found." }, status: :not_found
    end
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
                                    :preview_downloads, :preview_file)
    end
end

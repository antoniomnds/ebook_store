class EbooksController < ApplicationController
  before_action :set_ebook, only: %i[ show edit update destroy ]

  # GET /ebooks
  def index
    @ebooks = Ebook.all
  end

  # GET /ebooks/1
  def show
    @ebook.update_attribute(:views, @ebook.views + 1)
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
      ActiveRecord::Base.transaction do
        @ebook.destroy!
        @ebook.preview_file.purge_later
      end
      redirect_to ebooks_url, notice: "Ebook was successfully destroyed.", status: :see_other
    rescue StandardError => e
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
    rescue StandardError => e
      redirect_to ebooks_url, alert: "Ebook could not be purchased. #{ e.message }"
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

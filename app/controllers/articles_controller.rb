class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]

  # GET /articles or /articles.json
  def index
    @articles = cache_articles
  end

  # GET /articles/1 or /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    def cache_articles
      Rails.cache.fetch("cache_articles",expires_in: 60.minutes) do
        # Article.allだとキャッシュされない
        # Article.all
        Article.all.to_a
      end
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :body)
    end
end
# ログ
#1回目リクエスト　ActiveRecordへの問い合わせあり(0.3ms)
# Started GET "/articles" for ::1 at 2021-08-29 15:45:38 +0900
#    (0.1ms)  SELECT sqlite_version(*)
# Processing by ArticlesController#index as HTML
#   Article Load (0.3ms)  SELECT "articles".* FROM "articles"
#   ↳ app/controllers/articles_controller.rb:69:in `block in cache_articles'
#   Rendering articles/index.html.erb within layouts/application
#   Rendered articles/index.html.erb within layouts/application (Duration: 2.8ms | Allocations: 709)
# Completed 200 OK in 143ms (Views: 30.5ms | ActiveRecord: 0.3ms | Allocations: 7888)

#２ActiveRecordの問い合わせ無し(0.0ms)
# Started GET "/articles" for ::1 at 2021-08-29 15:45:44 +0900
# Processing by ArticlesController#index as HTML
#   Rendering articles/index.html.erb within layouts/application
#   Rendered articles/index.html.erb within layouts/application (Duration: 2.7ms | Allocations: 650)
# Completed 200 OK in 17ms (Views: 10.0ms | ActiveRecord: 0.0ms | Allocations: 2966)


# ３ActiveRecordの問い合わせ無し(0.0ms)

# Started GET "/articles" for ::1 at 2021-08-29 15:45:47 +0900
# Processing by ArticlesController#index as HTML
#   Rendering articles/index.html.erb within layouts/application
#   Rendered articles/index.html.erb within layouts/application (Duration: 0.8ms | Allocations: 650)
# Completed 200 OK in 7ms (Views: 3.2ms | ActiveRecord: 0.0ms | Allocations: 2969)

ActiveRecord::Base.transaction do
  Article.delete_all
  5.times do |index|
    Article.create!(
      title: "タイトル#{index}",
      body: "記事本文#{index}")
  end
end

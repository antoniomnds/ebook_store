Ebook.create! do |ebook|
  ebook.title = '1984'
  ebook.status = 'live'
  ebook.price = 0.99
  ebook.authors = 'George Orwell'
  ebook.publisher = 'Global Publishers'
  ebook.pages = 219
  ebook.publication_date = DateTime.parse('2024-03-02')
  ebook.isbn = '978-0451524935'
end

Ebook.create! do |ebook|
  ebook.title = 'Atomic Habits: An Easy & Proven Way to Build Good Habits & Break Bad Ones'
  ebook.status = 'live'
  ebook.price = 12.99
  ebook.authors = 'James Clear'
  ebook.publisher = 'Avery'
  ebook.pages = 320
  ebook.publication_date = DateTime.parse('2018-10-16')
  ebook.isbn = '978-0735211292'
end

Ebook.create! do |ebook|
  ebook.title = 'Nexus: A Brief History of Information Networks from the Stone Age to AI'
  ebook.status = 'live'
  ebook.price = 12.99
  ebook.authors = 'Yuval Noah Harari'
  ebook.publisher = 'Random House'
  ebook.pages = 528
  ebook.publication_date = DateTime.parse('2024-09-10')
  ebook.isbn = '978-0593734223'
end

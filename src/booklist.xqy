xdmp:set-response-content-type("text/html"),
('<!DOCTYPE html PUBLIC>',
<html>
  <head>
    <title>Book List</title>
    <link rel="stylesheet" href="styles/main.css"/>
  </head>
  <body>
    <div class="searchBar left column">
      Search
      <form>
        <fieldset>
          <legend>Search for a Book!</legend>
          <label for="bookTitle">Title</label><input type="text" id="bookTitle" name="bookTitle"></input>
          <label for="author">Author</label> <input type="text" id="author" name="author"/>
          <label for="year">Year</label> <input type="text" id="year" name="year"/>
          <label for="price">Price</label> <input type="text" id="price" name="price"/>
          <label for="category">Category</label>
          <select name="category" id="category">
            <option/>
              {
                for $c in ('CHILDREN','FICTION','NON-FICTION')
                return <option value="{$c}">{$c}</option>
              }
          </select>
          <input type="submit" value="Save"/>
        </fieldset>
      </form>
    </div>
    <div class="bookList right column">
      {
      for $book in fn:doc()/book
      return
        <section class="book">
          <h1 class="bookTitle">{$book/bookTitle}</h1>
          <div class="bookDetails">
            <div>by: {$book/author}</div>
            <div>released: {$book/year}</div>
            <div>Category: {fn:data($book/@category)}</div>
            <div>Price: ${$book/price}</div>
          </div>
        </section>
      }
    </div>
    <div></div>
  </body>

</html>)
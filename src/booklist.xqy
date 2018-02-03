xquery version "1.0-ml";

declare option xdmp:output "method = html";

declare function local:bookToSearch(
  $bookTitle as xs:string,
  $author as xs:string?,
  $year as xs:string?,
  $price as xs:string?,
  $category as xs:string?
  ) as xs:string {
    xdmp:log($bookTitle),
    xdmp:log($author),
    xdmp:log($year),
    xdmp:log($price),
    xdmp:log($category), (:So, now I'm just logging to see where the disconnect is:)
    let $search as xs:string := "true"  (: Obviously I just need to use xs:boolean for the way I'm using it in the html, but I couldn't figure it out quickly :)
    let $searchedBook as element(book) :=
     element book {
       attribute category { $category },
       element bookTitle { $bookTitle },
       element author { $author },
       element year { $year },
       element price { $price }
     }
     return $search, xdmp:log($searchedBook) (:So, logging here shows that the values aren't actuall being assigned in the above lines. Why??:)
  };

declare function local:searchBook($searchedBook as element(book)) as element(book)* {
  cts:search(//book, cts:element-value-query(xs:QName("bookTitle"), fn:data($searchedBook/bookTitle), ("wildcarded", "case-insensitive")))
};

declare function local:sanitizeInput($chars as xs:string?) {
    fn:replace($chars,"[\]\[<>{}\\();%\+]","")
};

declare variable $searchedBook as element(book) :=
  element book {
    attribute category {"CATEGORY"},
    element bookTitle {"default title"},
    element author {"author"},
    element year {1900},
    element price {0}
       };

declare variable $search as xs:string? :=
    if (xdmp:get-request-method() eq "POST") then (
      xdmp:log("Defining POST inputs as xs:strings"), (:So, now I'm just logging to see where the disconnect is:)
      let $bookTitle as xs:string? := local:sanitizeInput(xdmp:get-request-field("bookTitle"))
      let $author as xs:string? := local:sanitizeInput(xdmp:get-request-field("author"))
      let $year as xs:string? := local:sanitizeInput(xdmp:get-request-field("year"))
      let $price as xs:string? := local:sanitizeInput(xdmp:get-request-field("price"))
      let $category as xs:string? := local:sanitizeInput(xdmp:get-request-field("category"))
      return
        local:bookToSearch($bookTitle, $author, $year, $price, $category)
    ) else ();

(: build the html :)
xdmp:set-response-content-type("text/html"),
('<!DOCTYPE html PUBLIC>',
<html>
  <head>
    <title>Book List</title>
    <link rel="stylesheet" href="styles/main.css"/>
  </head>
  <body>
    <div class="header">HEADER GOES HERE</div>
    <div class="searchBar left column">
      <form name="bookSearch" action="booklist.xqy" method="post" id="searchForm">
        <fieldset>
          <legend>Search for a Book!</legend>
          <div><label for="bookTitle" class="searchKey">Title</label><input type="text" id="bookTitle" name="bookTitle"></input></div>
          <div><label for="author" class="searchKey">Author</label><input type="text" id="author" name="author"/></div>
          <div><label for="year" class="searchKey">Year</label><input type="text" id="year" name="year"/></div>
          <div><label for="price" class="searchKey">Price</label><input type="text" id="price" name="price"/></div>
          <div>
            <label for="category" class="searchKey">Category</label>
            <select name="category" id="category">
              <option/>
                {
                  for $c in ('CHILDREN','FICTION','NON-FICTION')
                  return <option value="{$c}">{$c}</option>
                }
            </select>
          </div>
          <div><input type="submit" value="Search"/></div>
        </fieldset>
      </form>
      <div>
        {
          if (fn:exists($search)) then (
            <div class="removeMe">
              <section class="book">
                <h1 class="bookTitle">{$searchedBook/bookTitle}</h1>
                <div class="bookDetails">
                  <div>by: {$searchedBook/author}</div>
                  <div>released: {$searchedBook/year}</div>
                  <div>Category: {fn:data($searchedBook/@category)}</div>
                  <div>Price: ${$searchedBook/price}</div>
                </div>
              </section>
              {
                for $book in local:searchBook($searchedBook)
                return $book
              }
            </div>
          ) else ()
        }
      </div>
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
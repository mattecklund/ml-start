xquery version "1.0-ml";

declare option xdmp:output "method = html";

declare variable $searchField as xs:string := "";
declare variable $searchTerm as xs:string := "";

declare function local:searchBook($searchField as xs:string, $searchTerm as xs:string) as element(book)* {
  cts:search(//book, cts:element-value-query(xs:QName($searchField), $searchTerm, ("wildcarded", "case-insensitive")))
};


(: Obviously I just ripped this off from the xquery tutorial on ML website. :)

declare function local:sanitizeInput($chars as xs:string?) {
    fn:replace($chars,"[\]\[<>{}\\();%\+]","") (:Obviously I just ripped this off from the add-boox.xqy:)
};

(: build the html :)
xdmp:set-response-content-type("text/html"),
('<!DOCTYPE html PUBLIC>',
<html>
  <head>
    <title>Book List</title>
    <link rel="stylesheet" href="styles/main.css"/>
  </head>
  <body>
    <div class="header">BOOK STORE</div>
    <div class="searchBar left column">
      <form name="bookSearch" action="booklist.xqy" method="post" id="searchForm">
        <fieldset>
          <legend>Search for a Book!</legend>
          <div>
            <label for="searchField" class="searchKey">Field</label>
            <select name="searchField" id="searchField">
              <option/>
                {
                  for $c in ('bookTitle','author','year','price','category') (:Ok, seriously, how do you put a switch or if/else statement in FLWOR??? I've tried a few different things...:)
                  (:where if($c = "bookTitle") then let $label := "Title":) (: else (continue?):)
                  (:where if($c = "author") then let $label := "Author":)
                  (:where if($c = "year") then let $label := "Year":)
                  (:where if($c = "price") then let $label := "Price":)
                  (:where if($c = "category") then let $label := "Category":)
                  return <option value="{$c}">{$c}</option>
                }
            </select>
          </div>
          <div><label for="searchTerm" class="searchKey">Terms</label><input type="text" id="searchTerm" name="searchTerm"></input></div>
          <div><input type="submit" value="Search"/></div>
        </fieldset>
      </form>
    </div>
    <div class="right column">
      <div><h2>Search Results</h2></div>
      <div class="bookList">
        { if (fn:exists(xdmp:get-request-field("searchField")) and fn:exists(xdmp:get-request-field("searchTerm"))) then
            for $book in local:searchBook(
              local:sanitizeInput(xdmp:get-request-field("searchField")),
              local:sanitizeInput(xdmp:get-request-field("searchTerm"))
              )
            return
              <section class="book">
                <h1 class="bookTitle">{$book/bookTitle}</h1>
                <div class="bookDetails">
                  <div>By: {$book/author}</div>
                  <div>Released: {$book/year}</div>
                  <div>Category: {fn:data($book/@category)}</div>
                  <div>Price: ${$book/price}</div>
                </div>
              </section>
          else ()
        }
      </div>
      <hr></hr>
      <div><h2>Book Database</h2></div>

        <div class="bookList">
          {
            for $book in doc()/book
            return
              <section class="book">
                <h1 class="bookTitle">{$book/bookTitle}</h1>
                <div class="bookDetails">
                  <div>By: {$book/author}</div>
                  <div>Released: {$book/year}</div>
                  <div>Category: {fn:data($book/@category)}</div>
                  <div>Price: ${$book/price}</div>
                </div>
              </section>
          }
        </div>
    </div>
    <div></div>
  </body>

</html>)
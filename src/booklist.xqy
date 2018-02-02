xquery version "1.0-ml";

xdmp:set-response-content-type("text/html"),
('<!DOCTYPE html PUBLIC>',
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
  <head>
    <title>Book List</title>
    <link rel="stylesheet" href="styles/main.css"/>
  </head>
  <body>
    <div class="column left pushLeft"></div>
    <div class="column center pushLeft">
      {
      for $book in fn:doc()
      return <section><h1>Book Title: </h1><p>{$book}</p></section>
      }
    </div>
    <div class="column right"></div>
  </body>

</html>)